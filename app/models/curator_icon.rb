class CuratorIcon < ApplicationRecord
  has_one_attached :icon
  validates :name, presence: true
  validates :icon, presence: true
  validate :correct_icon_type

  private

  def correct_icon_type
    return unless icon.attached?
    allowed_types = %w[image/png image/jpeg]
    errors.add(:icon, "must be a PNG or JPEG") unless icon.content_type.in?(allowed_types)
  end
end
