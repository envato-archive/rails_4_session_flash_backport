require 'base64'

require 'rails_4_session_flash_backport/rails3-0/flash_hash'

describe ActionDispatch::Flash::FlashHash, "backport" do
  context "#from_session_value" do
    subject(:flash) { described_class.from_session_value(value) }

    context "with rails 4 style session value" do
      context "without discards" do
        let(:value) { {"flashes" => {"greeting" => "Hello"}} }

        it "is the expected flash" do
          expect(flash.to_hash).to eq("greeting" => "Hello")
        end
      end

      context "with discards" do
        let(:value) { {"flashes" => {"greeting" => "Hello", "farewell" => "Goodbye"}, "discard" => ["farewell"]} }

        it "is the expected flash" do
          expect(flash.to_hash).to eq("greeting" => "Hello")
        end
      end
    end

    context "with rails 3.1 style session value" do
      # {"session_id"=>"f8e1b8152ba7609c28bbb17ec9263ba7", "flash"=>#<ActionDispatch::Flash::FlashHash:0x00000000000000 @used=#<Set: {"farewell"}>, @closed=false, @flashes={"greeting"=>"Hello", "farewell"=>"Goodbye"}, @now=nil>}
      let(:cookie) { 'BAh7B0kiD3Nlc3Npb25faWQGOgZFRkkiJWY4ZTFiODE1MmJhNzYwOWMyOGJiYjE3ZWM5MjYzYmE3BjsAVEkiCmZsYXNoBjsARm86JUFjdGlvbkRpc3BhdGNoOjpGbGFzaDo6Rmxhc2hIYXNoCToKQHVzZWRvOghTZXQGOgpAaGFzaHsGSSINZmFyZXdlbGwGOwBUVDoMQGNsb3NlZEY6DUBmbGFzaGVzewdJIg1ncmVldGluZwY7AFRJIgpIZWxsbwY7AFRJIg1mYXJld2VsbAY7AFRJIgxHb29kYnllBjsAVDoJQG5vdzA=' }
      let(:session) { Marshal.load(Base64.decode64(cookie)) }

      it "is breaks spectacularly" do
        expect { session }.to raise_error(/dump format error/)
      end
    end

    context "with rails 3.0 style session value" do
      # {"session_id"=>"f8e1b8152ba7609c28bbb17ec9263ba7", "flash"=>{"greeting"=>"Hello", "farewell"=>"Goodbye"}} # <= (actually a FlashHash < Hash)
      let(:cookie) { 'BAh7B0kiD3Nlc3Npb25faWQGOgZFVEkiJWY4ZTFiODE1MmJhNzYwOWMyOGJiYjE3ZWM5MjYzYmE3BjsAVEkiCmZsYXNoBjsAVElDOiVBY3Rpb25EaXNwYXRjaDo6Rmxhc2g6OkZsYXNoSGFzaHsHSSINZ3JlZXRpbmcGOwBUSSIKSGVsbG8GOwBUSSINZmFyZXdlbGwGOwBUSSIMR29vZGJ5ZQY7AFQGOgpAdXNlZG86CFNldAY6CkBoYXNoewZJIg1mYXJld2VsbAY7AFRU' }
      let(:session) { Marshal.load(Base64.decode64(cookie)) }
      let(:value) { session["flash"] }

      it "is the expected flash" do
        expect(flash.to_hash).to eq("greeting" => "Hello")
      end
    end

    context "with rails 2 style session value" do
      # {"session_id"=>"f8e1b8152ba7609c28bbb17ec9263ba7", "flash"=>#<ActionController::Flash::FlashHash:0x00000000000000 @used={"farewell"=>true}, {"greeting"=>"Hello", "farewell"=>"Goodbye"}>}
      let(:cookie) { 'BAh7B0kiD3Nlc3Npb25faWQGOgZFVEkiJWY4ZTFiODE1MmJhNzYwOWMyOGJiYjE3ZWM5MjYzYmE3BjsAVEkiCmZsYXNoBjsAVElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6Rmxhc2hIYXNoewdJIg1mYXJld2VsbAY7AFRJIgxHb29kYnllBjsAVEkiDWdyZWV0aW5nBjsAVEkiCkhlbGxvBjsAVAY6CkB1c2VkewZJIg1mYXJld2VsbAY7AFRU' }
      let(:session) { Marshal.load(Base64.decode64(cookie)) }
      let(:value) { session["flash"] }

      it "is the expected flash" do
        expect(flash.to_hash).to eq("greeting" => "Hello")
      end
    end
  end

  context "#to_session_value" do
    subject(:flash) { described_class.new }

    before do
      flash["greeting"] = "Hello"
      flash.now["farewell"] = "Goodbye"
    end

    it "dumps to basic objects like rails 4" do
      expect(flash.to_session_value).to eq("flashes" => {"greeting" => "Hello"})
    end
  end
end
