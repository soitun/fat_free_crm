# frozen_string_literal: true

# http://cyber.law.harvard.edu/rss/rss.html
item = @items.singularize

if item == 'task'
  @assets = @assets.values.flatten
  title = "#{t(:"#{@view}_tab")} #{t(@items.to_sym)}"
end

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.generator  "Fat Free CRM v#{FatFreeCRM::VERSION::STRING}"
    xml.link       send(:"#{@items}_url")
    xml.pubDate    Time.now.to_fs(:rfc822)
    xml.title      title || t(@items.to_sym)

    @assets.each do |asset|
      xml.item do
        url = send(:"#{item}_url", asset)
        xml.author      !asset.is_a?(User) ? asset.try(:user).try(:full_name) : asset.full_name
        xml.description send(:"#{item}_summary", asset) if respond_to?(:"#{item}_summary")
        xml.guid        url
        xml.link        url
        xml.pubDate     asset.created_at.to_fs(:rfc822)
        xml.title       !asset.is_a?(User) ? asset.name : "#{asset.full_name} (#{asset.username})"
      end
    end
  end
end
