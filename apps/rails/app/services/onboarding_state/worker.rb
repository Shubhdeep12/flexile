# frozen_string_literal: true

class OnboardingState::Worker < OnboardingState::BaseUser
  def complete?
    super
  end

  def redirect_path
    if !has_personal_details?
      spa_company_worker_onboarding_path(company.external_id)
    elsif !has_legal_details?
      spa_company_worker_onboarding_legal_path(company.external_id)
    elsif !has_bank_details? && !user.sanctioned_country_resident?
      spa_company_worker_onboarding_bank_account_path(company.external_id)
    end
  end

  def after_complete_onboarding_path
    # Rely on the front-end logic to redirect to the role-specific page.
    "/dashboard"
  end
end
