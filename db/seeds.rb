# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
print('Descargando Comunas y regiones')

consumer = DPAConsumer.new

regions = consumer.regions
puts('Regiones Descargadas')

regions.each do |region|
  region_db = Region.create(code: region['codigo'], name: region['nombre'], location: "POINT(#{region['lat']} #{region['lng']})")
  provinces = consumer.provinces_in_region(region['codigo'])
  provinces.each do |province|
    province_db = Province.create(
      code: province['codigo'],
      name: province['nombre'],
      location: "POINT(#{province['lat']} #{province['lng']})",
      parent_code: province['codigo_padre'],
      region: region_db)

    communes = consumer.communes_in_province(province['codigo'])
    communes.each do |commune|
      Commune.create(
        code: commune['codigo'],
        name: commune['nombre'],
        location: "POINT(#{commune['lat']} #{commune['lng']})",
        parent_code: commune['codigo_padre'],
        province: province_db,
        full_name: "#{commune['nombre']}, #{province_db.full_name}")
    end
  end
end

print('Descargando estaciones\n')

Station.sync_with_cne