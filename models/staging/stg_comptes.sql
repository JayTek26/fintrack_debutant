with source as (
    select * from {{ source('fintrack_raw', 'raw_comptes') }}
)
select
    id                as compte_id,
    nom_client,
    type_compte,
    lower(statut)     as statut,
    date_ouverture,
    solde_initial
from source
