require "test_helper"
require "minitest/mock"

require "generators/rails_icons/sync_generator"

class SyncGeneratorTest < Minitest::Test
  def test_calls_sync_on_engine
    sync_engine = Minitest::Mock.new
    sync_engine.expect(:now, nil)

    Icons::Sync.stub(:new, sync_engine) do
      RailsIcons::SyncGenerator.new([], libraries: ["heroicons"]).sync_icons
    end

    sync_engine.verify
  end
end
