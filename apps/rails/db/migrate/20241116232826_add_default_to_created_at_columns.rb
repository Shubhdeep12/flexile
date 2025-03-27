class AddDefaultToCreatedAtColumns < ActiveRecord::Migration[7.2]
  def change
    change_column_default :active_storage_attachments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :active_storage_blobs, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :balance_transactions, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :balances, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :companies, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_administrators, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_contractor_absences, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_contractor_update_tasks, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_contractor_updates, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_contractors, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_investor_entities, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_investors, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_lawyers, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_monthly_financial_reports, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_role_applications, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_role_rates, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_roles, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_stripe_accounts, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_updates, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :company_updates_financial_reports, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :consolidated_invoices, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :consolidated_invoices_invoices, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :consolidated_payments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :contractor_profiles, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :contracts, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :convertible_investments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :convertible_securities, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :daily_tasks, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :dividend_computation_outputs, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :dividend_computations, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :dividend_payments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :dividend_rounds, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :dividends, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :dividends_dividend_payments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :document_signatures, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :documents, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_allocations, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_buyback_payments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_buyback_rounds, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_buybacks, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_buybacks_equity_buyback_payments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_exercise_bank_accounts, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_grant_exercise_requests, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_grant_exercises, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_grant_transactions, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :equity_grants, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :expense_card_charges, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :expense_cards, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :expense_categories, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :financing_rounds, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :integration_records, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :integrations, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :investor_dividend_rounds, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :invoice_approvals, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :invoice_expenses, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :invoice_line_items, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :invoices, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :option_pools, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :payments, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :pg_search_documents, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :share_classes, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :share_holdings, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :tasks, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :tax_documents, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :tender_offer_bids, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :tender_offers, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :time_entries, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :tos_agreements, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :user_compliance_infos, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :user_leads, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :users, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :vesting_events, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :vesting_schedules, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :wallets, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :wise_credentials, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
    change_column_default :wise_recipients, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }
  end
end
