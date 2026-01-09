# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/helpers/decidim/layout_helper.rb" => "7941b929e6db4115b9ecba270e215c47",
      "/app/views/layouts/decidim/_head_extra.html.erb" => "25642b423f3b3a1ac9c69bf558a6b791",
      # Devise mailers
      "/app/views/devise/mailer/invitation_instructions.html.erb" => "b91d1abb95c177c7a1e589d3b219aed9",
      "/app/views/devise/mailer/invite_private_user.html.erb" => "f978eddb05fa55af2c33ce78c964a2bb",
      "/app/views/devise/mailer/reset_password_instructions.html.erb" => "40e2a215f87b399286f9039be73af22c"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      next unless spec

      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
