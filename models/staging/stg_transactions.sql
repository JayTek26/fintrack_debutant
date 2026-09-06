with source as (
    select * from {{ source('fintrack_raw', 'raw_transactions') }}
)
select
    id                                          as transaction_id,
    compte_id,
    categorie_id,
    cast(date_transaction as timestamp_ntz)     as date_transaction,
    montant,
    type_operation,
    statut,
    case
        when type_operation = 'credit' then montant
        else -montant
    end                                          as montant_signe
from source
