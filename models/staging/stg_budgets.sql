with source as (
    select * from {{ source('fintrack_raw', 'raw_budgets') }}
)
select
    id                    as budget_id,
    compte_id,
    categorie_id,
    cast(mois as date)    as mois,
    montant               as montant_prevu
from source
