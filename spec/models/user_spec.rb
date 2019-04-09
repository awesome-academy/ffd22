require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.build :user}
  subject{user}

  describe "validates" do
    context "when create is valid" do
      it {is_expected.to be_valid}
    end

    context "when name is nil" do
      before {subject.name = nil}
      it {is_expected.to have(1).error_on(:name)}
      it do
        subject.valid?
        expect(subject.errors.messages[:name].first).to eq(
          I18n.t "test.models.user.name.blank")
      end
    end

    context "when name is too long" do
      before {subject.name = "c" * 55}
      it {is_expected.to have(1).error_on(:name)}
      it do
        subject.valid?
        expect(subject.errors.messages[:name].first).to eq(
          I18n.t "test.models.user.name.too_long")
      end
    end

    context "when email is nil" do
      before {subject.email = nil}
      it {is_expected.to have(1).error_on(:email)}
      it do
        subject.valid?
        expect(subject.errors.messages[:email].first).to eq(
          I18n.t "test.models.user.email.blank")
      end
    end

    context "when email is invalid email format" do
      before {subject.email = "abc.d"}
      it {is_expected.to have(1).error_on(:email)}
      it do
        subject.valid?
        expect(subject.errors.messages[:email].first).to eq(
          I18n.t "test.models.user.email.invalid")
      end
    end

    context "when email is duplicate" do
      before {@another_user = FactoryBot.create :user}
      it {is_expected.to have(1).error_on(:email)}
      it do
        subject.valid?
        expect(subject.errors.messages[:email].first).to eq(
          I18n.t "test.models.user.email.unique")
      end
    end

    context "when password is nil" do
      before {subject.password = nil}
      it {is_expected.to have(1).error_on(:password)}
      it do
        subject.valid?
        expect(subject.errors.messages[:password].first).to eq(
          I18n.t "test.models.user.password.blank")
      end
    end

    context "when password is too short" do
      before {subject.password = "123"}
      it {is_expected.to have(1).error_on(:password)}
      it do
        subject.valid?
        expect(subject.errors.messages[:password].first).to eq(
          I18n.t "test.models.user.password.too_short")
      end
    end

    context "when password is too long" do
      before {subject.password = "123" * 128}
      it {is_expected.to have(1).error_on(:password)}
      it do
        subject.valid?
        expect(subject.errors.messages[:password].first).to eq(
          I18n.t "test.models.user.password.too_long")
      end
    end
  end

  describe "association" do
    shared_examples "has many" do |parameter|
      it {is_expected.to have_many(parameter).dependent :destroy}
    end

    context "with suggestions" do
      it_behaves_like "has many", :suggestions
    end

    context "with comments" do
      it_behaves_like "has many", :comments
    end

    context "with orders" do
      it_behaves_like "has many", :orders
    end
  end

  describe "role" do
    context "when define enum is admin or normal user" do
      it {is_expected.to define_enum_for(:role).
        with_values %i(admin normal_user)}
    end
  end
end
