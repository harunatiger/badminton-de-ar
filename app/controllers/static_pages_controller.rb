class StaticPagesController < ApplicationController

  def cancel_policy_en
  end

  def service_agreement_en
  end

  def specific_commercial_transactions_en
  end

  def privacy_policy_en
  end

  def cancel_policy_jp
  end

  def service_agreement_jp
  end

  def specific_commercial_transactions_jp
  end

  def privacy_policy_jp
  end

  def about
  end

  def plan4U
    file_path = Rails.root.join(Settings.plan4U.s3_content_path.header)
    @s3_header = File.exist?(file_path) ? File.read(file_path) : ''

    file_path = Rails.root.join(Settings.plan4U.s3_content_path.middle)
    @s3_middle = File.exist?(file_path) ? File.read(file_path) : ''

    file_path = Rails.root.join(Settings.plan4U.s3_content_path.footer)
    @s3_footer = File.exist?(file_path) ? File.read(file_path) : ''
  end

  def plan4U_kyoto
    file_path = Rails.root.join(Settings.plan4U_kyoto.s3_content_path.header)
    @s3_header = File.exist?(file_path) ? File.read(file_path) : ''

    file_path = Rails.root.join(Settings.plan4U_kyoto.s3_content_path.middle)
    @s3_middle = File.exist?(file_path) ? File.read(file_path) : ''

    file_path = Rails.root.join(Settings.plan4U_kyoto.s3_content_path.footer)
    @s3_footer = File.exist?(file_path) ? File.read(file_path) : ''
  end

  def plan4U_hokkaido
    file_path = Rails.root.join(Settings.plan4U_hokkaido.s3_content_path.header)
    @s3_header = File.exist?(file_path) ? File.read(file_path) : ''

    file_path = Rails.root.join(Settings.plan4U_hokkaido.s3_content_path.middle)
    @s3_middle = File.exist?(file_path) ? File.read(file_path) : ''

    file_path = Rails.root.join(Settings.plan4U_hokkaido.s3_content_path.footer)
    @s3_footer = File.exist?(file_path) ? File.read(file_path) : ''
  end

  def three_reasons
  end

  def our_partners
  end
end
