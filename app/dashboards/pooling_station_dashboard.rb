require "administrate/base_dashboard"

class PoolingStationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    desa_kelurahan: Field::BelongsTo,
    kpu_id: Field::Number,
    kpu_kode: Field::String,
    kpu_nama: Field::String,
    kpu_tingkat: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    desa_kelurahan
    kpu_id
    kpu_kode
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    desa_kelurahan
    kpu_id
    kpu_kode
    kpu_nama
    kpu_tingkat
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    desa_kelurahan
    kpu_id
    kpu_kode
    kpu_nama
    kpu_tingkat
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how pooling stations are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(pooling_station)
    "#{pooling_station.desa_kelurahan.kpu_nama} #{pooling_station.kpu_nama}"
  end
end
