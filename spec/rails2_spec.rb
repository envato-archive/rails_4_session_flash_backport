require 'action_controller'
require 'rails_4_session_flash_backport/rails2'

describe ActionController::Flash::FlashHash, "monkey patches" do

  it "turns from a magic rails object into a plain hash to go in the session" do

    flash = subject

    flash[:errors] = "an error!"

    flash.to_session_value.should == {"discard" => [],
                                      "flashes" => {:errors => "an error!"},
                                      "used"    => {:errors => false}}

    flash.sweep
    flash[:notice] = "a notice"

    flash.to_session_value.should == {"discard" => [:errors],
                                      "flashes" => {:errors => "an error!", :notice => "a notice"},
                                      "used"    => {:errors => true, :notice => false}}

    flash.sweep

    flash.to_session_value.should == {"discard" => [:notice],
                                      "flashes" => {:notice => "a notice"},
                                      "used"    => {:notice => true}}

    flash.now['qux'] = 1

    flash.to_session_value.should == {"discard" => [:notice, 'qux'],
                                      "flashes" => {:notice => "a notice", 'qux' => 1},
                                      "used"    => {:notice => true, 'qux' => true }}

    flash.to_session_value.class.should == Hash

  end

  it "turns from a plain hash from the session into a magic rails object" do

    flash_hash = described_class.from_session_value( { "flashes" => {:errors => "an error!"},
                                                       "used"    => {:errors => false}})
    flash_hash.class.should == described_class

    flash_hash[:errors].should == "an error!"

    # This is nasty!
    flash_hash.instance_variable_get("@used")[:errors].should be_false

    flash_hash = described_class.from_session_value( { "flashes" => {:errors => "an error!"},
                                                       "used"    => {:errors => true}})
    flash_hash[:errors].should == "an error!"

    # This is nasty!
    flash_hash.instance_variable_get("@used")[:errors].should be_true
    flash_hash.sweep
    flash_hash[:errors].should be_nil

  end

end
# describe ActionDispatch::Flash::FlashHash, "hax" do
#
#   let(:rails_2_marshaled) { "\x04\bIC:'ActionController::Flash::FlashHash{\a:\vnoticeI\"\x11I'm a notice\x06:\x06ET:\nerrorI\"\x11I'm an error\x06;\aT\x06:\n@used{\a;\x06T;\bF" }
#   let(:rails_2_vanilla) { Marshal.load(rails_2_marshaled) }
#
#   let(:rails_3_vanilla) { described_class.new.tap do |hash|
#     hash[:notice] = "I'm a notice"
#     hash.sweep
#     hash[:error] = "I'm an error"
#   end }
#
#   let(:rails_4_style) { {'flashes' => {:notice => "I'm a notice", :error => "I'm an error"}, 'discard' => [:notice]} }
#
#   it "happily unmarshals a Rails 2 session without exploding" do
#     Marshal.load(rails_2_marshaled).should be_a(ActionController::Flash::FlashHash)
#   end
#
#   context "#from_session_value" do
#     def this_is_the_flash_hash_were_looking_for(flash_hash)
#       flash_hash.should be_a(described_class)
#       flash_hash[:notice].should == "I'm a notice"
#       flash_hash[:error].should == "I'm an error"
#       flash_hash.sweep
#       flash_hash[:notice].should be_nil
#       flash_hash[:error].should == "I'm an error"
#     end
#
#     it "decodes rails 2 style to an empty FlashHash" do
#       this_is_the_flash_hash_were_looking_for = ActionDispatch::Flash::FlashHash.from_session_value(rails_2_vanilla)
#     end
#
#     it "decodes rails 3 style to a FlashHash" do
#       this_is_the_flash_hash_were_looking_for = ActionDispatch::Flash::FlashHash.from_session_value(rails_3_vanilla)
#     end
#
#     it "decodes rails 4 style to a FlashHash" do
#       this_is_the_flash_hash_were_looking_for ActionDispatch::Flash::FlashHash.from_session_value(rails_4_style)
#     end
#   end
#
#   context "#to_session_value" do
#     it "dumps to basic objects like rails 4" do
#       rails_3_vanilla.to_session_value.should be_a(Hash)
#       rails_3_vanilla.to_session_value.should == rails_4_style
#     end
#   end
#
# end
