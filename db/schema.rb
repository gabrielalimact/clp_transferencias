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

ActiveRecord::Schema[7.1].define(version: 2024_02_26_150608) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "usuario_pixes", force: :cascade do |t|
    t.integer "id_usuario"
    t.string "chave_pix"
    t.string "tipo_chave"
    t.float "saldo"
    t.boolean "chave_ativa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
