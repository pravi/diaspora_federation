module DiasporaFederation
  module Entities
    # this is a module that defines common properties for relayable entities
    # which include Like, Comment, Participation, Message, etc. Each relayable
    # has a parent, identified by guid. Relayables also are signed and signing/verification
    # logic is embedded into Salmon XML processing code.
    module Relayable
      include Logging

      # digest instance used for signing
      DIGEST = OpenSSL::Digest::SHA256.new

      # on inclusion of this module the required properties for a relayable are added to the object that includes it
      #
      # @!attribute [r] author
      #   The diaspora ID of the author.
      #   @see Person#author
      #   @return [String] diaspora ID
      #
      # @!attribute [r] guid
      #   a random string of at least 16 chars.
      #   @see Validation::Rule::Guid
      #   @return [String] comment guid
      #
      # @!attribute [r] parent_guid
      #   @see StatusMessage#guid
      #   @return [String] parent guid
      #
      # @!attribute [r] author_signature
      #   Contains a signature of the entity using the private key of the author of a post itself.
      #   The presence of this signature is mandatory. Without it the entity won't be accepted by
      #   a target pod.
      #   @return [String] author signature
      #
      # @!attribute [r] parent_author_signature
      #   Contains a signature of the entity using the private key of the author of a parent post
      #   This signature is required only when federation from upstream (parent) post author to
      #   downstream subscribers. This is the case when the parent author has to resend a relayable
      #   received from one of his subscribers to all others.
      #
      #   @return [String] parent author signature
      #
      # @param [Entity] entity the entity in which it is included
      def self.included(entity)
        entity.class_eval do
          property :author, xml_name: :diaspora_handle
          property :guid
          property :parent_guid
          property :author_signature, default: nil
          property :parent_author_signature, default: nil
        end
      end

      # verifies the signatures (+author_signature+ and +parent_author_signature+ if needed)
      # @raise [SignatureVerificationFailed] if the signature is not valid or no public key is found
      def verify_signatures
        pubkey = DiasporaFederation.callbacks.trigger(:fetch_public_key_by_diaspora_id, author)
        raise PublicKeyNotFound, "author_signature author=#{author} guid=#{guid}" if pubkey.nil?
        raise SignatureVerificationFailed, "wrong author_signature" unless verify_signature(pubkey, author_signature)

        parent_author_local = DiasporaFederation.callbacks.trigger(:entity_author_is_local?, parent_type, parent_guid)
        verify_parent_author_signature unless parent_author_local
      end

      private

      # this happens only on downstream federation
      def verify_parent_author_signature
        pubkey = DiasporaFederation.callbacks.trigger(:fetch_author_public_key_by_entity_guid, parent_type, parent_guid)

        raise PublicKeyNotFound, "parent_author_signature parent_guid=#{parent_guid} guid=#{guid}" if pubkey.nil?
        unless verify_signature(pubkey, parent_author_signature)
          raise SignatureVerificationFailed, "wrong parent_author_signature parent_guid=#{parent_guid}"
        end
      end

      # Check that signature is a correct signature
      #
      # @param [OpenSSL::PKey::RSA] pubkey An RSA key
      # @param [String] signature The signature to be verified.
      # @return [Boolean] signature valid
      def verify_signature(pubkey, signature)
        if signature.nil?
          logger.warn "event=verify_signature status=abort reason=no_signature guid=#{guid}"
          return false
        end

        pubkey.verify(DIGEST, Base64.decode64(signature), signature_data).tap do |valid|
          logger.info "event=verify_signature status=complete guid=#{guid} valid=#{valid}"
        end
      end

      # sign with author key
      # @raise [AuthorPrivateKeyNotFound] if the author private key is not found
      # @return [String] A Base64 encoded signature of #signature_data with key
      def sign_with_author
        privkey = DiasporaFederation.callbacks.trigger(:fetch_private_key_by_diaspora_id, author)
        raise AuthorPrivateKeyNotFound, "author=#{author} guid=#{guid}" if privkey.nil?
        sign_with_key(privkey).tap do
          logger.info "event=sign status=complete signature=author_signature author=#{author} guid=#{guid}"
        end
      end

      # sign with parent author key, if the parent author is local (if the private key is found)
      # @return [String] A Base64 encoded signature of #signature_data with key
      def sign_with_parent_author_if_available
        privkey = DiasporaFederation.callbacks.trigger(
          :fetch_author_private_key_by_entity_guid, parent_type, parent_guid
        )
        if privkey
          sign_with_key(privkey).tap do
            logger.info "event=sign status=complete signature=parent_author_signature guid=#{guid}"
          end
        end
      end

      # Sign the data with the key
      #
      # @param [OpenSSL::PKey::RSA] privkey An RSA key
      # @return [String] A Base64 encoded signature of #signature_data with key
      def sign_with_key(privkey)
        Base64.strict_encode64(privkey.sign(DIGEST, signature_data))
      end

      # Sort all XML elements according to the order used for the signatures.
      # It updates also the signatures with the keys of the author and the parent
      # if the signatures are not there yet and if the keys are available.
      #
      # @return [Hash] sorted xml elements with updated signatures
      def xml_elements
        xml_data = super.merge(additional_xml_elements)
        Hash[signature_order.map {|element| [element, xml_data[element]] }].tap do |xml_elements|
          xml_elements[:author_signature] = author_signature || sign_with_author
          xml_elements[:parent_author_signature] = parent_author_signature || sign_with_parent_author_if_available.to_s
        end
      end

      # the order for signing
      # @return [Array]
      def signature_order
        xml_order.nil? ? self.class::LEGACY_SIGNATURE_ORDER : xml_order.reject {|name| name =~ /signature/ }
      end

      # @return [String] signature data string
      def signature_data
        data = to_h.merge(additional_xml_elements)
        signature_order.map {|name| data[name] }.join(";")
      end

      # Exception raised when creating the author_signature failes, because the private key was not found
      class AuthorPrivateKeyNotFound < RuntimeError
      end

      # Exception raised when verify_signatures fails to verify signatures (no public key found)
      class PublicKeyNotFound < RuntimeError
      end

      # Exception raised when verify_signatures fails to verify signatures (signatures are wrong)
      class SignatureVerificationFailed < RuntimeError
      end
    end
  end
end
