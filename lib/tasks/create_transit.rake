namespace :transit do
  task create_lines: :environment do
    source = GTFS::Source.build("#{Rails.root}/tmp/google_transit.zip")
    source.routes.each do |r|
      Line.create(
        api_id: r.id,
        name: r.long_name,
        system_type: r.type,
      )
    end
  end

  task create_stops: :environment do
    source = GTFS::Source.build("#{Rails.root}/tmp/google_transit.zip")
    source.stops.each do |s|
      Stop.create(
        api_id: s.id,
        name: s.name,
        longitude: s.lon,
        lattitude: s.lat,
      )
    end
  end

  task pair_stops: :environment do
    Stop.all.group_by do |s|
      [s.longitude, s.lattitude]
    end
    .each do |latlong, stops|
      original, *twins = stops
      twins.each do |twin|
        twin.twin_stop_id = original.id
        twin.save
      end
    end
  end

  #task populate_lines: :environment do
  #  GTFS::Source.build("#{Rails.root}/tmp/google_transit.zip")
  #end


end