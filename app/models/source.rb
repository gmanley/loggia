class Source < ActiveRecord::Base
  include Autocompleteable

  POSSIBLE_KINDS = %w(photographer website)

  has_and_belongs_to_many :images, -> { uniq }

  validates :kind, presence: true,
                   inclusion: {
                     in: POSSIBLE_KINDS,
                     message: "%{value} is not a valid kind of source"
                   }

  validates :name, presence: true,
                   uniqueness: { scope: :kind }

  def self.of_kind(kind)
    where(kind: kind)
  end

  def self.websites
    of_kind('website')
  end

  def self.photographers
    of_kind('photographers')
  end

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
