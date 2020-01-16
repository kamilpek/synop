object false
node (:alerts_count) { @alerts.size }
child @alerts do
  attributes :intro, :content
  node(:number) do |m|
    "#{m.number}/#{m.created_at.strftime("%Y")}"
  end
  node(:level) do |m|
    m.level
  end
  node(:created_at) do |m|
    m.created_at.strftime("%d.%m.%Y, %H:%M")
  end
  node(:time_from) do |m|
    m.time_from.strftime("%d.%m.%Y, %H:%M")
  end
  node(:time_for) do |m|
    m.time_for.strftime("%d.%m.%Y, %H:%M")
  end
  node(:category) do |m|
    Category.find(m.category_id).name
  end
  node(:author) do |m|
    User.find(m.user_id).first_name + " " + User.find(m.user_id).last_name
  end
  node(:clients) do |m|
    Client.where(id: m.clients.compact).pluck(:name)
  end
  node(:image) do |m|
    image = Category.find(m.category_id).image.thumb.url
    if (image.nil?)
      ""
    else
      (URI.parse(root_url) + Category.find(m.category_id).image.thumb.url).to_s
    end
  end
end
