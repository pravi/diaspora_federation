module DiasporaFederation
  describe Entities::Relayable do
    let(:author_serialized_key) {
      <<-KEY
-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQCxTbMp+M5sCUDVi9k1wMxedSwyLQcjBKQa0Qs6Qpnflz0k90hh
btau0cy9jTK6S3CK2GhERXD6EecDlhZCbnSI9Bwmco5j6NbGPN5ai9tWgiBZzaEr
yOVMQ4qCh1fKOMPX/LCvPzH+K7f8Q92zCuSvKSofg6zpg1zxGahpmxwqFQIDAQAB
AoGBAKEXD2la/XF7FsTuwvLrsMNBgl40Ov+9/7u9oo3UZSmYp50mb0TXB4beZz7x
Qt2wHRiJdnJRBUyvZ00C2EaTRJyFJA8p5J2qzHSjGpbPGyRCZUB6r6y+9vbM4ouj
m5Vo47TQ7ob2D835BHJGR8dWM1zeAwWc6uLhNIu+/5lHQ90BAkEA6aVQFSXNYjmO
fo6Oro+2nDaoa4jJ9qO1S23P2HF9N2f7CHDB4WKTdYnZpXs7ZPbnMEz62LeSC1MZ
QOKGYkMuDQJBAMJEZWvfWtp+Zwm+IF1xGbNPzGrvHGJarE/QGUGYs7BR7tHFlepR
aV3g56eGWfCWk8oWZRbjC2eQ2we96CU4cikCQQCqp3BCwgWthNSrY3yby6RZnSKO
yK6bUx+MJHz3Xo1S9sPIenNiKBoEc9dgow3SxPQ/tzpRKGOnmd6MIeh9xQvRAkAV
6WEHKco1msxEbQ15fKhJcVa9OPsanN+SoQY4P+EEojktr/uY0lXwIM4AN0ctu84v
nRcJ3dILfGs4FFN630MBAkEA3zMOyNTeNdHrVhZc5b0qw2T6FUJGieDpOWLsff4w
84yW10oS2CCmqEhbfh4Wu22amglytrATwD9hDzsTNAt8Mg==
-----END RSA PRIVATE KEY-----
KEY
    }
    let(:author_key) { OpenSSL::PKey::RSA.new(author_serialized_key) }
    # -----BEGIN PUBLIC KEY-----
    # MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCxTbMp+M5sCUDVi9k1wMxedSwy
    # LQcjBKQa0Qs6Qpnflz0k90hhbtau0cy9jTK6S3CK2GhERXD6EecDlhZCbnSI9Bwm
    # co5j6NbGPN5ai9tWgiBZzaEryOVMQ4qCh1fKOMPX/LCvPzH+K7f8Q92zCuSvKSof
    # g6zpg1zxGahpmxwqFQIDAQAB
    # -----END PUBLIC KEY-----

    let(:parent_serialized_key) {
      <<-KEY
-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQDrOvW1UArKoUOg54XWXcTD3jU0zKG3Pm9IeaEzfQtApogQ3+M/
F9nz0i3q8UhTDEPBQ3hMbqJ/4qfY+wFulxMR58DbqxFx9QcNZISUd0CPx/fJOYMx
R7bygTbiCet4FAiyMjxOX3Oei/DedUNps1RAP1bu+80iibze/Kk9BgMm0QIDAQAB
AoGAMHvikRCCaOl8SvnteBWzrLtsNAnJez9/KG0JcNdhLl4kxXWgHS0JW1wC4t4A
jj2E6ZzCet6C1+Ebv3lc/jJdV3pCK3wgX0YAt/oBW5kcuvpLHLSWusWHnHkYU+qO
4SdC3bRhdLV9o3u/oCWzmdeKTdqIyNd2yAbb3W1TsD4EsQECQQD6w+vWVKhWbVOj
Ky3ZkLCxPcWNUt+7OIzDA1OLKhdhe44hIoRMfDT6iLK3sJTSjgOv0OFTfsdOqh5y
ZqYp/CTpAkEA8CQFKkAYt4qG1lKMPsU/Tme0/Z24VozDRnyw7r663f0De+25kXGY
PSBiOHYcAE6poYQEtR/leLTSaG3YZm7hqQJBAOLAWLg1Uwbb0v4/pDUQlgWfQsy4
/KAx0W7hyiCTzhKTBAFIUfNLeSh2hYx+ewQt8H2B1s6GXDjwsZlm4qgiXUkCQQC9
B12ZeIL8V2r0Yl5LOvEuQqxRx0lHt94vKhAMns5x16xabTLZrlVsKIWodDBufX1B
yq359XWooo3N7kmduEKhAkEAppzKLuVtX1XPL4VZBex/M2ewngjkSg964BvxIBwv
bFzeSqlMpnbEoOJ9hhx6CsP6Y7V19DRRXi0XgwcAjHLz8g==
-----END RSA PRIVATE KEY-----
KEY
    }
    let(:parent_key) { OpenSSL::PKey::RSA.new(parent_serialized_key) }
    # -----BEGIN PUBLIC KEY-----
    # MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrOvW1UArKoUOg54XWXcTD3jU0
    # zKG3Pm9IeaEzfQtApogQ3+M/F9nz0i3q8UhTDEPBQ3hMbqJ/4qfY+wFulxMR58Db
    # qxFx9QcNZISUd0CPx/fJOYMxR7bygTbiCet4FAiyMjxOX3Oei/DedUNps1RAP1bu
    # +80iibze/Kk9BgMm0QIDAQAB
    # -----END PUBLIC KEY-----

    let(:author) { "alice@pod-a.org" }
    let(:guid) { "e21589b0b41101333b870f77ba60fa73" }
    let(:parent_guid) { "9e269ae0b41201333b8c0f77ba60fa73" }
    let(:new_data) { "foobar" }
    let(:text) { "this is a very informative comment" }

    let(:comment) {
      Entities::Comment.new(author: author, guid: guid, parent_guid: parent_guid, text: text, new_data: new_data)
    }

    let(:legacy_comment_xml_alice) {
      <<-XML
<XML>
  <post>
    <comment>
      <diaspora_handle>alice@pod-a.org</diaspora_handle>
      <guid>e21589b0b41101333b870f77ba60fa73</guid>
      <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
      <author_signature>XU5X1uqTh8SY6JMG9uhEVR5Rg7FURV6lpRwl/HYOu6DJ3Hd9tpA2aSFFibUxxsMgJXKNrrc5SykrrEdTiQoEei+j0QqZf3B5R7r84qgK7M46KazwIpqRPwVl2MdA/0DdQyYJLA/oavNj1nwll9vtR87M7e/C94qG6P+iQTMBQzo=</author_signature>
      <parent_author_signature/>
      <text>this is a very informative comment</text>
    </comment>
  </post>
</XML>
XML
    }
    let(:new_signature_comment_xml_alice) {
      <<-XML
<comment>
  <author>alice@pod-a.org</author>
  <guid>e21589b0b41101333b870f77ba60fa73</guid>
  <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
  <author_signature>SQbLeqsEpFmSl74G1fFJXKQcsq6jp5B2ZjmfEOF/LbBccYP2oZEyEqOq18K3Fa71OYTp6Nddb38hCmHWWHvnGUltGfxKBnQ0WHafJUi40VM4VmeRoU8cac6m+1hslwe5SNmK6oh47EV3mRCXlgGGjLIrw7iEwjKL2g9x1gkNp2s=</author_signature>
  <parent_author_signature/>
  <text>this is a very informative comment</text>
</comment>
XML
    }
    let(:new_data_comment_xml_alice) {
      <<-XML
<comment>
  <author>alice@pod-a.org</author>
  <guid>e21589b0b41101333b870f77ba60fa73</guid>
  <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
  <author_signature>cu3CtmtXjqBZDCdXgCOopQlVYGkQZYMZEZgRGs/+d3+C5mMeJ2nQNgM7qoCcmcKEz9iuDvADCxiyBtM0etAbCTzasxR/pbN0/qgNhbmV0vVD5/pqV60VlmOn3SseITlwmd7ftETvq4W5+yz2H/HJjtaHLM0zeSiECjWjqSvzT0Q=</author_signature>
  <parent_author_signature/>
  <new_data>foobar</new_data>
  <text>this is a very informative comment</text>
</comment>
XML
    }

    let(:legacy_comment_xml_bob) {
      <<-XML
<XML>
  <post>
    <comment>
      <diaspora_handle>alice@pod-a.org</diaspora_handle>
      <guid>e21589b0b41101333b870f77ba60fa73</guid>
      <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
      <author_signature>XU5X1uqTh8SY6JMG9uhEVR5Rg7FURV6lpRwl/HYOu6DJ3Hd9tpA2aSFFibUxxsMgJXKNrrc5SykrrEdTiQoEei+j0QqZf3B5R7r84qgK7M46KazwIpqRPwVl2MdA/0DdQyYJLA/oavNj1nwll9vtR87M7e/C94qG6P+iQTMBQzo=</author_signature>
      <parent_author_signature>QqWSdwpb+/dcJUxuKKVe7aiz1NivXzlIdWZ71xyrxnhFxFYd+7EIittyTcp1cVehjg96pwDbn++P/rWyCffqenWu025DHvUfSmQkC93Z0dX6r3OIUlZqwEggtOdbunybiE++F3BVsGt5wC4YbAESB5ZFuhFVhBXh1X+EaZ/qoKo=</parent_author_signature>
      <text>this is a very informative comment</text>
    </comment>
  </post>
</XML>
XML
    }
    let(:legacy_new_signature_comment_xml_bob) {
      <<-XML
<XML>
  <post>
    <comment>
      <diaspora_handle>alice@pod-a.org</diaspora_handle>
      <guid>e21589b0b41101333b870f77ba60fa73</guid>
      <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
      <author_signature>SQbLeqsEpFmSl74G1fFJXKQcsq6jp5B2ZjmfEOF/LbBccYP2oZEyEqOq18K3Fa71OYTp6Nddb38hCmHWWHvnGUltGfxKBnQ0WHafJUi40VM4VmeRoU8cac6m+1hslwe5SNmK6oh47EV3mRCXlgGGjLIrw7iEwjKL2g9x1gkNp2s=</author_signature>
      <parent_author_signature>QqWSdwpb+/dcJUxuKKVe7aiz1NivXzlIdWZ71xyrxnhFxFYd+7EIittyTcp1cVehjg96pwDbn++P/rWyCffqenWu025DHvUfSmQkC93Z0dX6r3OIUlZqwEggtOdbunybiE++F3BVsGt5wC4YbAESB5ZFuhFVhBXh1X+EaZ/qoKo=</parent_author_signature>
      <text>this is a very informative comment</text>
    </comment>
  </post>
</XML>
      XML
    }
    let(:new_signature_comment_xml_bob) {
      <<-XML
<comment>
  <author>alice@pod-a.org</author>
  <guid>e21589b0b41101333b870f77ba60fa73</guid>
  <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
  <author_signature>SQbLeqsEpFmSl74G1fFJXKQcsq6jp5B2ZjmfEOF/LbBccYP2oZEyEqOq18K3Fa71OYTp6Nddb38hCmHWWHvnGUltGfxKBnQ0WHafJUi40VM4VmeRoU8cac6m+1hslwe5SNmK6oh47EV3mRCXlgGGjLIrw7iEwjKL2g9x1gkNp2s=</author_signature>
  <parent_author_signature>hWsagsczmZD6d36d6MFdTt3hKAdnRtupSIU6464G2kkMJ+WlExxMgbF6kWR+jVCBTeKipWCYK3Arnj0YkuIZM9d14bJGVMTsW/ZzNfJ69bXZhsyawI8dPnZnLVydo+hU/XmGJBEuh2TOj9Emq6/HCYiWzPTF5qhYAtyJ1oxJ4Yk=</parent_author_signature>
  <text>this is a very informative comment</text>
</comment>
      XML
    }
    let(:legacy_new_data_comment_xml_bob) {
      <<-XML
<XML>
  <post>
    <comment>
      <diaspora_handle>alice@pod-a.org</diaspora_handle>
      <guid>e21589b0b41101333b870f77ba60fa73</guid>
      <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
      <author_signature>cu3CtmtXjqBZDCdXgCOopQlVYGkQZYMZEZgRGs/+d3+C5mMeJ2nQNgM7qoCcmcKEz9iuDvADCxiyBtM0etAbCTzasxR/pbN0/qgNhbmV0vVD5/pqV60VlmOn3SseITlwmd7ftETvq4W5+yz2H/HJjtaHLM0zeSiECjWjqSvzT0Q=</author_signature>
      <parent_author_signature>KXfObxPPMtajzVk9Y7Zv3WmqO6jkOtMUAANz3WvWfu498hXuo8erZwyZpvyn166gDO+R4c0D3oJVj4RPnzIO7KaAZ28wzpZ4M4HiiSK2N3Y3SXmy2zjQxpf5HPnfkB+OWMDN51JohpYIAzKvsEZ9Wnzq7AiziWN3EbqJWRr4M9A=</parent_author_signature>
      <text>this is a very informative comment</text>
      <new_data>foobar</new_data>
    </comment>
  </post>
</XML>
      XML
    }
    let(:new_data_comment_xml_bob) {
      <<-XML
<comment>
  <author>alice@pod-a.org</author>
  <guid>e21589b0b41101333b870f77ba60fa73</guid>
  <parent_guid>9e269ae0b41201333b8c0f77ba60fa73</parent_guid>
  <author_signature>cu3CtmtXjqBZDCdXgCOopQlVYGkQZYMZEZgRGs/+d3+C5mMeJ2nQNgM7qoCcmcKEz9iuDvADCxiyBtM0etAbCTzasxR/pbN0/qgNhbmV0vVD5/pqV60VlmOn3SseITlwmd7ftETvq4W5+yz2H/HJjtaHLM0zeSiECjWjqSvzT0Q=</author_signature>
  <parent_author_signature>KXfObxPPMtajzVk9Y7Zv3WmqO6jkOtMUAANz3WvWfu498hXuo8erZwyZpvyn166gDO+R4c0D3oJVj4RPnzIO7KaAZ28wzpZ4M4HiiSK2N3Y3SXmy2zjQxpf5HPnfkB+OWMDN51JohpYIAzKvsEZ9Wnzq7AiziWN3EbqJWRr4M9A=</parent_author_signature>
  <new_data>foobar</new_data>
  <text>this is a very informative comment</text>
</comment>
      XML
    }

    # this was used to create the XMLs above
    context "test-data creation" do
      it "creates comment xml" do
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_private_key_by_diaspora_id, author
        ).and_return(author_key)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_author_private_key_by_entity_guid, "Post", parent_guid
        ).and_return(nil)

        comment.to_xml
      end

      it "creates relayed comment xml" do
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_public_key_by_diaspora_id, author
        ).and_return(author_key.public_key)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :entity_author_is_local?, "Post", parent_guid
        ).and_return(true)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_author_private_key_by_entity_guid, "Post", parent_guid
        ).and_return(parent_key)

        xml = Nokogiri::XML::Document.parse(new_data_comment_xml_alice).root
        Salmon::XmlPayload.unpack(xml).to_xml
      end
    end

    context "relaying on bobs pod" do
      before do
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_public_key_by_diaspora_id, author
        ).and_return(author_key.public_key)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :entity_author_is_local?, "Post", parent_guid
        ).and_return(true)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_author_private_key_by_entity_guid, "Post", parent_guid
        ).and_return(parent_key)
      end

      it "relays legacy signatures and xml" do
        xml = Nokogiri::XML::Document.parse(legacy_comment_xml_alice).root
        entity = Salmon::XmlPayload.unpack(xml)
        expect(Salmon::XmlPayload.pack(entity).to_xml).to eq(legacy_comment_xml_bob.strip)
      end

      it "relays new signatures and xml" do
        xml = Nokogiri::XML::Document.parse(new_signature_comment_xml_alice).root
        entity = Salmon::XmlPayload.unpack(xml)
        expect(Salmon::XmlPayload.pack(entity).to_xml).to eq(legacy_new_signature_comment_xml_bob.strip)
      end

      it "relays new signatures with new data" do
        xml = Nokogiri::XML::Document.parse(new_data_comment_xml_alice).root
        entity = Salmon::XmlPayload.unpack(xml)
        expect(Salmon::XmlPayload.pack(entity).to_xml).to eq(legacy_new_data_comment_xml_bob.strip)
      end
    end

    context "parsing on every other pod" do
      before do
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_public_key_by_diaspora_id, author
        ).and_return(author_key.public_key)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :entity_author_is_local?, "Post", parent_guid
        ).and_return(false)
        expect(DiasporaFederation.callbacks).to receive(:trigger).with(
          :fetch_author_public_key_by_entity_guid, "Post", parent_guid
        ).and_return(parent_key.public_key)
      end

      it "parses legacy signatures and xml" do
        xml = Nokogiri::XML::Document.parse(legacy_comment_xml_bob).root
        entity = Salmon::XmlPayload.unpack(xml)

        expect(entity.author).to eq(author)
        expect(entity.text).to eq(text)
      end

      it "parses new signatures with legacy xml" do
        xml = Nokogiri::XML::Document.parse(legacy_new_signature_comment_xml_bob).root
        entity = Salmon::XmlPayload.unpack(xml)

        expect(entity.author).to eq(author)
        expect(entity.text).to eq(text)
      end

      it "parses new signatures and xml" do
        xml = Nokogiri::XML::Document.parse(new_signature_comment_xml_bob).root
        entity = Salmon::XmlPayload.unpack(xml)

        expect(entity.author).to eq(author)
        expect(entity.text).to eq(text)
      end

      it "parses new data with legacy xml" do
        xml = Nokogiri::XML::Document.parse(legacy_new_data_comment_xml_bob).root
        entity = Salmon::XmlPayload.unpack(xml)

        expect(entity.author).to eq(author)
        expect(entity.text).to eq(text)
        expect(entity.additional_xml_elements["new_data"]).to eq(new_data)
      end

      it "parses new xml with additional data" do
        xml = Nokogiri::XML::Document.parse(new_data_comment_xml_bob).root
        entity = Salmon::XmlPayload.unpack(xml)

        expect(entity.author).to eq(author)
        expect(entity.text).to eq(text)
        expect(entity.additional_xml_elements["new_data"]).to eq(new_data)
      end
    end
  end
end
