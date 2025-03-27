# frozen_string_literal: true

class CompanyWorkerMailer < ApplicationMailer
  helper :application
  default from: SUPPORT_EMAIL_WITH_NAME

  def contract_ended(company_worker_id: nil, company_contractor_id: nil)
    id = find_id!(company_worker_id:, company_contractor_id:)
    @company_worker = CompanyWorker.find(id)
    return unless @company_worker.alumni?
    @company = @company_worker.company
    @user = @company_worker.user
    mail(to: @user.email, reply_to: @company.email, subject: "Your contract with #{@company.name} is ending")
  end

  def invite_worker(company_worker_id)
    @company_worker = CompanyWorker.find(company_worker_id)
    @company = @company_worker.company
    @user = @company_worker.user
    mail(to: @user.email, reply_to: @company.email, subject: "You're invited to #{@company.name}'s team")
  end

  def equity_grant_issued(equity_grant_id)
    @equity_grant = EquityGrant.find(equity_grant_id)
    @company = @equity_grant.option_pool.company
    @user = @equity_grant.company_investor.user

    mail(to: @user.email, reply_to: @company.email,
         subject: "🔴 Action needed: sign your Incentive Plan to receive stock options")
  end

  def vesting_event_processed(vesting_event_id)
    @vesting_event = VestingEvent.find(vesting_event_id)
    @equity_grant = @vesting_event.equity_grant
    @company = @equity_grant.option_pool.company
    user = @equity_grant.company_investor.user

    mail(
      to: user.email,
      reply_to: @company.email,
      subject: "#{@vesting_event.vested_shares} options in the option grant issued to you vested"
    )
  end

  def invoice_rejected(invoice_id:, reason: nil)
    @reason = reason
    @invoice = Invoice.find(invoice_id)
    return unless @invoice.rejected?
    mail(to: @invoice.user.email, reply_to: @invoice.company.email,
         subject: "Action required: Invoice #{@invoice.invoice_number}")
  end

  def invoice_approved(invoice_id:)
    @invoice = Invoice.find(invoice_id)
    @company = @invoice.company
    @user = @invoice.user
    @bank_account = @user.bank_account
    @payment_descriptions = @invoice.invoice_line_items.pluck(:description) unless @invoice.invoice_type_services?

    mail(to: @user.email, reply_to: @company.email, subject: "✅ #{@company.name} approved your invoice!")
  end

  def payment_sent(payment_id)
    @payment = Payment.find(payment_id)
    @invoice = @payment.invoice
    user = @invoice.user
    @company = @invoice.company

    mail(to: user.email, reply_to: @company.email, subject: "💰 #{@company.name} just paid you!")
  end

  def payment_failed_reenter_bank_details(payment_id, amount, currency)
    @payment = Payment.find(payment_id)
    @invoice = @payment.invoice
    @currency = currency
    @amount = amount
    company = @invoice.company
    user = @invoice.user

    mail(to: user.email, reply_to: company.email, subject: "🔴 Payment failed: re-enter your bank details")
  end

  def equity_percent_selection(company_worker_id)
    company_worker = CompanyWorker.find(company_worker_id)
    @company = company_worker.company
    user = company_worker.user

    mail(to: user.email, reply_to: @company.email, subject: "🆕 Join #{@company.name}'s equity program")
  end

  def confirm_tax_info_reminder(company_worker_id: nil, company_contractor_id: nil, tax_year:)
    id = find_id!(company_worker_id:, company_contractor_id:)
    company_worker = CompanyWorker.find(id)
    user = company_worker.user
    @company = company_worker.company
    @has_tax_info_confirmed = user.tax_information_confirmed_at.present?
    @tax_year = tax_year
    @formatted_deadline_date = Date.new(tax_year + 1, 1, 30).to_fs(:medium)
    subject = "🔴 Action needed: #{@has_tax_info_confirmed ? "Review" : "Complete"} your tax information"

    mail(to: user.email, reply_to: company_worker.company.email, subject:)
  end

  def expense_card_grant(company_worker_id: nil, company_contractor_id: nil)
    id = find_id!(company_worker_id:, company_contractor_id:)
    company_worker = CompanyWorker.find(id)
    user = company_worker.user
    @company_role = company_worker.company_role
    @company = company_worker.company

    mail(to: user.email, reply_to: @company.email, subject: "💳 You just got an expense card!")
  end

  def invite_company(company_worker_id: nil, company_contractor_id: nil, url:)
    id = find_id!(company_worker_id:, company_contractor_id:)
    @company_worker = CompanyWorker.find(id)
    @company = @company_worker.company
    @url = url

    mail(to: @company_worker.company.primary_admin.user.email, subject: "You've been invited to Flexile")
  end

  private
    def find_id!(company_worker_id:, company_contractor_id:)
      raise "Either company_worker_id or company_contractor_id must be provided" if company_worker_id.blank? && company_contractor_id.blank?

      company_worker_id || company_contractor_id
    end
end
