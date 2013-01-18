require 'minitest_helper'

class ProgramTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  def setup
    @program = build(:program)
    # @program = Program.new(name: "Test Program", short_name: "test-program")
  end

  test "should not save program without name and short name" do
    program = Program.new
    refute program.save, "Saved without a name and short name"
  end

  test "should not save if short_name is incorrectly formatted" do
    @program.short_name = "test_program"
    refute @program.save, "Saved with an incorrectly formatted short name"
  end

  test "should not save if short_name is over 100 characters long" do
    @program.short_name = 't' * 101
    refute @program.save, "Saved with a short_name over 100 characters long"
  end

  test "should not save if instagram_client_id and instagram_client_secret are over 32 characters long" do
    @program.instagram_client_id = '1' * 33
    refute @program.save, "Saved with a instagram_client_id over 32 characters long"

    @program.instagram_client_secret = '1' * 33
    refute @program.save, "Saved with a instagram_client_secret over 32 characters long"
  end

  test "should generate a new program access key upon creation" do
    assert_not_nil !@program.program_access_key, "Program access key has not been generated"
  end

  test "should generate a new program access key" do
    original_program_access_key = @program.program_access_key
    @program.generate_program_access_key
    new_program_access_key = @program.program_access_key
    assert_not_equal original_program_access_key, new_program_access_key, "Program did not generate a new access key"
  end

  test "should authenticate using program access key" do
    key = @program.program_access_key
    assert @program.authenticate(key), "Program has not been authenticated"
  end

  test "should not be active on creation" do
    refute @program.active, "Program is active"
  end

  test "activate method should activate program" do
    @program.update_attribute(:active, false)
    @program.activate
    assert @program.active, "Program has not been activated"
  end

  test "deactivate method should deactivate program" do
    @program.update_attribute(:active, true)
    @program.deactivate
    refute @program.active, "Program has not been deactivated"
  end

  test "photo_tags method should get an array of photo import tags without IDs" do
    tags = ['tag_one', 'tag_two', 'tag_three']
    tags.each do |tag|
      @program.program_photo_import_tags << ProgramPhotoImportTag.new(:tag => tag)
    end
    @program.save
    assert_equal @program.photo_tags - tags, [], "Tags retrieved do not match tags saved"
  end

  test "should be set to active once if past the active date" do
    @program.active = false
    @program.date_to_activate = 1.minute.ago
    @program.save
    @program.activate_on_date
    assert @program.active, "Program has not been activated"

    @program.active = false
    @program.save
    @program.activate_on_date
    refute @program.active, "Program activated more than once"
  end

  test "should be set to inactive once if past the inactive date" do
    @program.active = true
    @program.date_to_deactivate = 1.minute.ago
    @program.save
    @program.deactivate_on_date
    refute @program.active, "Program has not been deactivated"

    @program.active = true
    @program.save
    @program.deactivate_on_date
    assert @program.active, "Program deactivated more than once"
  end

  test "should destroy instances of owned ProgramApp when destroyed" do
    # 3.times do |i|
    #   @program.program_apps << ProgramApp.new(:name => "App: #{i}")
    # end
    @program.program_apps = build_list(:program_app, 3)
    @program.save
    @program.destroy

    assert_empty @program.program_apps, "ProgramApp instances were not destroyed"
  end
end
