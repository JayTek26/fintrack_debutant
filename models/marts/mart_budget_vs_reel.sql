with budgets_agreges as (
    select
        compte_id,
        categorie_id,
        mois,
        sum(montant_prevu) as montant_prevu
    from {{ ref('stg_budgets') }}
    group by compte_id, categorie_id, mois
),
depenses_agregees as (
    select
        compte_id,
        categorie_id,
        mois_transaction as mois,
        sum(abs(montant_signe)) as montant_reel
    from {{ ref('fct_transactions') }}
    where montant_signe < 0
    group by compte_id, categorie_id, mois_transaction
),
combine as (
    select
        coalesce(b.compte_id, d.compte_id)       as compte_id,
        coalesce(b.categorie_id, d.categorie_id) as categorie_id,
        coalesce(b.mois, d.mois)                 as mois,
        b.montant_prevu,
        d.montant_reel
    from budgets_agreges b
    full outer join depenses_agregees d
        on  b.compte_id    = d.compte_id
        and b.categorie_id = d.categorie_id
        and b.mois         = d.mois
)
select
    c.compte_id,
    dc.nom_client,
    c.categorie_id,
    cat.nom_categorie,
    c.mois,
    c.montant_prevu,
    c.montant_reel,
    coalesce(c.montant_reel, 0) - coalesce(c.montant_prevu, 0)  as ecart,
    coalesce(c.montant_reel, 0) > coalesce(c.montant_prevu, 0)  as depassement
from combine c
left join {{ ref('dim_comptes') }}    dc  on c.compte_id    = dc.compte_id
left join {{ ref('dim_categories') }} cat on c.categorie_id = cat.categorie_id
order by c.compte_id, c.mois, c.categorie_id
