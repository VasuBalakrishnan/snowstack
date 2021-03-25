
{{ config(materialized='table') }}

with country as (
    select '' as country_code,
        '' as short_name,
        '' as table_name,
        '' as long_name,
        '' as alpha_code,
        '' as currency_unit,
        '' as special_notes,
        '' as region,
        '' as income_group,
        '' as wb2_code,
        '' as national_accounts_base_year,
        '' as national_accounts_reference_year,
        '' as sna_price_valuation,
        '' as lending_category,
        '' as other_groups,
        '' as system_of_national_accounts,
        '' as alternative_conversion_factor,
        '' as ppp_survey_year,
        '' as balance_of_payments_manual_in_use,
        '' as external_debt_reporting_status,
        '' as system_of_trade,
        '' as government_ccounting_concept,
        '' as imf_data_dissemination_standard,
        '' as latest_population_census,
        '' as latest_household_survey,
        '' as source_of_most_recent_income_and_expenditure_data,
        '' as vital_registration_complete,
        '' as latest_agricultural_census,
        '' as latest_industrial_data,
        '' as latest_trade_data
        where 1 = 0
)

select * 
  from country