class AddPlaylistEmbed < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        s = Season.where(:name => 'Winter 2016').first
        s.new_header_content = '<div class="music"><iframe width="560" height="315" src="https://www.youtube.com/embed/videoseries?list=PLPUcDCy2b25s5-Cc6HhxrTRn-8OB1Tagk" frameborder="0" allowfullscreen></iframe></div>'
        s.save
      end
    end
  end
end