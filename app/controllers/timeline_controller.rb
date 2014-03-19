class TimelineController < ApplicationController
  class Item
    attr_accessor :date
    attr_accessor :description
  end

  class ItemList < Array
  end

  class LogFile < Redcarpet::Render::Base
    def initialize *args
      super *args

      @list = ItemList.new
    end

    def preprocess doc
      doc.gsub /\n/, "\n\n"
    end

    def normal_text text
      text
    end

    def paragraph text
      item = Item.new
      item.date = @date
      item.description = text.gsub /\/n/, '<br>'
      @list << item
      ""
      #"<b>#{@date}:</b> #{text.gsub /\n/, '<br>'}<br>"
    end

    def header title, level, anchor
      case level
      when 2
        @date = title
      end
    end

    def postprocess doc
      @list
    end
  end

  def index
    name = '/Users/sander/Dropbox/Notational/log.txt'
    source = File.read name
    #Redcarpet::Render::HTML
    markdown = Redcarpet::Markdown.new LogFile
    #@content = markdown.render(source).html_safe
    @list = markdown.render source
  end
end
