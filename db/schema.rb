# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 1994_02_11_000013) do
  create_table "candidate_results", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "total_vote"
    t.bigint "candidate_id", null: false
    t.bigint "result_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id", "result_id"], name: "index_candidate_results_on_candidate_id_and_result_id", unique: true
    t.index ["candidate_id"], name: "index_candidate_results_on_candidate_id"
    t.index ["result_id"], name: "index_candidate_results_on_result_id"
  end

  create_table "candidates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "kpu_kode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "desa_kelurahans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "kpu_nama"
    t.integer "kpu_id"
    t.string "kpu_kode"
    t.integer "kpu_tingkat"
    t.bigint "kecamatan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kecamatan_id"], name: "index_desa_kelurahans_on_kecamatan_id"
  end

  create_table "kabupaten_kotas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "kpu_nama"
    t.integer "kpu_id"
    t.string "kpu_kode"
    t.integer "kpu_tingkat"
    t.bigint "provinsi_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provinsi_id"], name: "index_kabupaten_kotas_on_provinsi_id"
  end

  create_table "kecamatans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "kpu_nama"
    t.integer "kpu_id"
    t.string "kpu_kode"
    t.integer "kpu_tingkat"
    t.bigint "kabupaten_kota_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kabupaten_kota_id"], name: "index_kecamatans_on_kabupaten_kota_id"
  end

  create_table "pooling_stations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "kpu_nama"
    t.integer "kpu_id"
    t.string "kpu_kode"
    t.integer "kpu_tingkat"
    t.bigint "desa_kelurahan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["desa_kelurahan_id"], name: "index_pooling_stations_on_desa_kelurahan_id"
  end

  create_table "provinsis", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "kpu_nama"
    t.integer "kpu_id"
    t.string "kpu_kode"
    t.integer "kpu_tingkat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "result_sources", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "result_trackers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "result_id"
    t.string "key"
    t.text "value"
    t.text "old_value"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["result_id"], name: "index_result_trackers_on_result_id"
  end

  create_table "results", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.json "data"
    t.json "backup_images_with_hash"
    t.string "screenshoot_url"
    t.bigint "pooling_station_id", null: false
    t.bigint "result_source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pooling_station_id"], name: "index_results_on_pooling_station_id"
    t.index ["result_source_id"], name: "index_results_on_result_source_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verificators", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "candidate_results", "candidates"
  add_foreign_key "candidate_results", "results"
  add_foreign_key "desa_kelurahans", "kecamatans"
  add_foreign_key "kabupaten_kotas", "provinsis"
  add_foreign_key "kecamatans", "kabupaten_kotas"
  add_foreign_key "pooling_stations", "desa_kelurahans"
  add_foreign_key "result_trackers", "results"
  add_foreign_key "results", "pooling_stations"
  add_foreign_key "results", "result_sources"
end
