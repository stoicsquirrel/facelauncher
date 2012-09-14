class RenameFrameToScreenshotInVideo < ActiveRecord::Migration
  def change
    rename_column :videos, :frame, :screenshot
  end
end
