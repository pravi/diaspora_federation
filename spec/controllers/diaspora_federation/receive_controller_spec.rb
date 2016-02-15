module DiasporaFederation
  describe ReceiveController, type: :controller do
    routes { DiasporaFederation::Engine.routes }

    describe "POST #public" do
      context "legacy salmon slap" do
        it "returns a 422 if no xml is passed" do
          post :public
          expect(response.code).to eq("422")
        end

        it "returns a 422 if no xml is passed with content-type application/x-www-form-urlencoded" do
          @request.env["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
          post :public
          expect(response.code).to eq("422")
        end

        it "returns a 202 if queued correctly" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(:queue_public_receive, "<diaspora/>", true)

          post :public, xml: "<diaspora/>"
          expect(response.code).to eq("202")
        end

        it "unescapes the xml before sending it to the callback" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(:queue_public_receive, "<diaspora/>", true)

          post :public, xml: CGI.escape("<diaspora/>")
        end
      end

      context "magic envelope" do
        before do
          @request.env["CONTENT_TYPE"] = "application/magic-envelope+xml"
        end

        it "returns a 202 if queued correctly" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(:queue_public_receive, "<me:env/>", false)

          post :public, "<me:env/>"
          expect(response.code).to eq("202")
        end
      end
    end

    describe "POST #private" do
      context "legacy salmon slap" do
        it "return a 404 if not queued successfully (unknown user guid)" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(
            :queue_private_receive, "any-guid", "<diaspora/>", true
          ).and_return(false)

          post :private, guid: "any-guid", xml: "<diaspora/>"
          expect(response.code).to eq("404")
        end

        it "returns a 422 if no xml is passed" do
          post :private, guid: "any-guid"
          expect(response.code).to eq("422")
        end

        it "returns a 422 if no xml is passed with content-type application/x-www-form-urlencoded" do
          @request.env["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
          post :private, guid: "any-guid"
          expect(response.code).to eq("422")
        end

        it "returns a 202 if the callback returned true" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(
            :queue_private_receive, "any-guid", "<diaspora/>", true
          ).and_return(true)

          post :private, guid: "any-guid", xml: "<diaspora/>"
          expect(response.code).to eq("202")
        end

        it "unescapes the xml before sending it to the callback" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(
            :queue_private_receive, "any-guid", "<diaspora/>", true
          ).and_return(true)

          post :private, guid: "any-guid", xml: CGI.escape("<diaspora/>")
        end
      end

      context "encrypted magic envelope" do
        before do
          @request.env["CONTENT_TYPE"] = "application/json"
        end

        it "return a 404 if not queued successfully (unknown user guid)" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(
            :queue_private_receive, "any-guid", "{\"aes_key\": \"key\", \"encrypted_magic_envelope\": \"env\"}", false
          ).and_return(false)

          post :private, "{\"aes_key\": \"key\", \"encrypted_magic_envelope\": \"env\"}", guid: "any-guid"
          expect(response.code).to eq("404")
        end

        it "returns a 202 if the callback returned true" do
          expect(DiasporaFederation.callbacks).to receive(:trigger).with(
            :queue_private_receive, "any-guid", "{\"aes_key\": \"key\", \"encrypted_magic_envelope\": \"env\"}", false
          ).and_return(true)

          post :private, "{\"aes_key\": \"key\", \"encrypted_magic_envelope\": \"env\"}", guid: "any-guid"
          expect(response.code).to eq("202")
        end
      end
    end
  end
end
