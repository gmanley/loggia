class Source < ActiveRecord::Base
  include Autocompleteable

  POSSIBLE_KINDS = %w[photographer website]

  validates :kind, presence: true,
                   inclusion: {
                     in: POSSIBLE_KINDS,
                     message: "%{value} is not a valid kind of source"
                   }

  validates :name, presence: true,
                   uniqueness: { scope: :kind }

  has_and_belongs_to_many :images, -> { uniq }

  scope :websites, -> { where(kind: 'website') }

  scope :photographers, -> { where(kind: 'photographer') }

  def self.merge!(source_ids)
    sources = where(id: source_ids).order(:created_at)

    merged_source = sources.shift
    merged_source.images << sources.map(&:images)

    sources.destroy_all if merged_source.save(validate: false)
  end

  def name=(name)
    self[:name] = name.strip
  end

  def to_s
    name
  end
end
