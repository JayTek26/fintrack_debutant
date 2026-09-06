select
    compte_id,
    nom_client,
    type_compte,
    statut,
    date_ouverture,
    solde_initial,
    datediff('day', date_ouverture, current_date())  as anciennete_jours
from {{ ref('stg_comptes') }}
