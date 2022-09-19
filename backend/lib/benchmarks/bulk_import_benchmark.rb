require 'benchmark'

class BulkImportBenchmark
  def initialize(times)
    @times = times
    ActiveRecord::LogSubscriber.logger.level = Logger::ERROR
    #ActiveRecord::LogSubscriber.logger.level = Logger::DEBUG
  end

  def compare_bulk_insert
    ActiveRecord::Base.transaction do

      Benchmark.bm 23 do |r|
        users = []

        r.report "prepare models" do
          @times.times do
            users << FactoryBot.build(:user)
          end
        end

        users_as_hash = users.map { |u| u.attributes }

        r.report "bulk insert by model" do
          User.import users
        end

        r.report "bulk insert by hash" do
          User.import users_as_hash
        end

        r.report "insert for each" do
          users_as_hash.each do |u|
            User.create(u)
          end
        end
      end

      raise ActiveRecord::Rollback
    end
  end

  def compare_bulk_update
    ActiveRecord::Base.transaction do

      Benchmark.bm 23 do |r|
        users_as_hash = []

        r.report "prepare models" do
          @times.times do
            users_as_hash << FactoryBot.build(:user).attributes
          end
        end

        r.report "bulk insert by hash" do
          User.import users_as_hash
        end

        updating_users = User.all.map { |u| u }

        r.report "update model for each" do
          updating_users.each do |u|
            u.memo08 = 'hogeee'
            u.save
          end
        end

        r.report "update column for each" do
          updating_users.each do |u|
            u.update_column(:memo08, 'fugaaa')
          end
        end

        r.report "bulk update by model" do
          User.import updating_users,
                      validate: false, raise_error: true, timestamps: false,
                      on_duplicate_key_update: { conflict_target: [:id], columns: [:memo08] }
        end

        updating_users_as_hash = updating_users.map { |u| u.attributes }

        r.report "bulk update by hash" do
          User.import updating_users_as_hash,
                      validate: false, raise_error: true, timestamps: false,
                      on_duplicate_key_update: { conflict_target: [:id], columns: [:memo08] }
        end
      end

      raise ActiveRecord::Rollback
    end
  end
end