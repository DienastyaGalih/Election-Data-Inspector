# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Seeding user'
User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')
puts 'Seeding candidate'
Candidate.create!(
  [
    {
      id: 1,
      name: 'Anies - Muhaimin',
      kpu_kode: '100025'
    },
    {
      id: 2,
      name: 'Prabowo - Gibran',
      kpu_kode: '100026'
    },
    {
      id: 3,
      name: 'Ganjar - Mahfud',
      kpu_kode: '100027'
    }
  ]
)

puts 'Seeding result source'
ResultSource.create!(
  [
    {
      id: 1,
      name: 'KPU_HITUNG_SUARA'
    },
    {
      id: 2,
      name: 'KPU_REKAPITULASI_HASIL_PEMILU'
    },
    {
      id: 3,
      name: 'KPU_PENETAPAN_HASIL_PEMILU'
    },
    {
      id: 4,
      name: 'KAWAL_PEMILU'
    }
  ]
)
puts 'Seeding pooling level'
InitData::InitTingkatKpu.run!
