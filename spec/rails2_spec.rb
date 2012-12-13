require 'action_controller'
require 'rails_4_session_flash_backport/rails2'

describe ActionController::Flash::FlashHash, "hax" do

  let(:rails_2_marshaled) { "\x04\bIC:'ActionController::Flash::FlashHash{\a:\vnoticeI\"\x11I'm a notice\x06:\x06ET:\nerrorI\"\x11I'm an error\x06;\aT\x06:\n@used{\a;\x06T;\bF" }
  let(:rails_3_marshaled) { "\x04\bo:%ActionDispatch::Flash::FlashHash\t:\n@usedo:\bSet\x06:\n@hash{\x06:\vnoticeT:\f@closedF:\r@flashes{\a;\tI\"\x11I'm a notice\x06:\x06EF:\nerrorI\"\x11I'm an error\x06;\fF:\t@now0" }
  let(:rails_2_vanilla)   { Marshal.load(rails_2_marshaled) }
  let(:rails_3_vanilla)   { Marshal.load(rails_3_marshaled) }
  let(:rails_4_style)     { {'flashes' => {:notice => "I'm a notice", :error => "I'm an error"}, 'discard' => [:notice]} }

   it "happily unmarshals a Rails 3 session without exploding" do
     Marshal.load(rails_3_marshaled).should be_a(ActionDispatch::Flash::FlashHash)
   end

   context "#to_session_value" do
     it "dumps to basic objects like rails 4" do
       rails_2_vanilla.to_session_value.should be_a(Hash)
       rails_2_vanilla.to_session_value.should == rails_4_style
     end
   end

  context "#from_session_value" do
    def this_is_the_flash_hash_were_looking_for(flash_hash)
      flash_hash.should be_a(described_class)
      flash_hash[:notice].should == "I'm a notice"
      flash_hash[:error].should == "I'm an error"
      flash_hash.sweep
      flash_hash[:notice].should be_nil
      flash_hash[:error].should == "I'm an error"
    end

    it "decodes rails 2 style to an empty FlashHash" do
      this_is_the_flash_hash_were_looking_for(ActionController::Flash::FlashHash.from_session_value(rails_2_vanilla))
    end

    it "decodes rails 3 style to a FlashHash" do
      this_is_the_flash_hash_were_looking_for(ActionController::Flash::FlashHash.from_session_value(rails_3_vanilla))
    end

    it "decodes rails 4 style to a FlashHash" do
      this_is_the_flash_hash_were_looking_for(ActionController::Flash::FlashHash.from_session_value(rails_4_style))
    end
  end
end
