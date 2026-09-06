with transactions_mensuelles as (
    select
        compte_id,
        mois_transaction                                              as mois,
        sum(case when montant_signe > 0 then montant_signe else 0 end) as total_credits,
        sum(case when montant_signe < 0 then montant_signe else 0 end) as total_debits,
        sum(montant_signe)                                             as solde_net_mois
    from {{ ref('fct_transactions') }}
    group by compte_id, mois_transaction
),
avec_solde_initial as (
    select
        tm.compte_id,
        tm.mois,
        tm.total_credits,
        tm.total_debits,
        tm.solde_net_mois,
        dc.solde_initial
    from transactions_mensuelles tm
    left join {{ ref('dim_comptes') }} dc on tm.compte_id = dc.compte_id
)
select
    compte_id,
    mois,
    total_credits,
    total_debits,
    solde_net_mois,
    solde_initial + sum(solde_net_mois) over (
        partition by compte_id order by mois
        rows between unbounded preceding and current row
    )  as solde_cumule
from avec_solde_initial
order by compte_id, mois
