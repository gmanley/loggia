class ImageConsolidator
  include BaseWorker

  def perform
    Image.where(md5: nil).pluck(:id).each do |record_id|
      ImageChecksumer.perform_async(record_id)
    end

    images = Image.select(:md5).from(
      Image.select(:md5,
        'ROW_NUMBER() OVER (
           PARTITION BY md5, album_id
           ORDER BY id
         ) AS row_num'
      ).where.not(md5: nil)
    ).where('subquery.row_num > 1')

    duplicate_pairs = Image.where(md5: images.map(&:md5)).group_by(&:md5).values
    duplicates = duplicate_pairs.map do |dupes|
      with_sources = dupes.select { |dupe| !dupe.sources.empty?  }
      if with_sources.empty?
        keeper = dupes.pop
      else
        keeper = with_sources.first
        dupes.reject! { |dupe| dupe.id == keeper.id }
      end

      Rails.logger.tagged('ImageConsolidator') do |logger|
        logger.info("Keeping image #{keeper.id}.")
        logger.info("Deleting #{dupes.length} other duplicates: #{dupes.map(&:id).to_sentence}.")
      end

      dupes.map(&:id)
    end.flatten

    Rails.logger.tagged('ImageConsolidator') do |logger|
      logger.info("Deleting #{duplicates.count} images")
    end

    Image.destroy(duplicates)
  end
end
