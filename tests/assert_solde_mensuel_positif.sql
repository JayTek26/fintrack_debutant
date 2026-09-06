select
    m.compte_id,
    m.mois,
    m.solde_cumule
from {{ ref('mart_solde_mensuel') }} m
inner join {{ ref('dim_comptes') }} dc on m.compte_id = dc.compte_id
where dc.type_compte = 'epargne'
  and m.solde_cumule < 0
