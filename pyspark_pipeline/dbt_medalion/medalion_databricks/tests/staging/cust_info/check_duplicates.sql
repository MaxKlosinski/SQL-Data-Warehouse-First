-- Catch dupliceates with the oldest date from base.
-- Expectations: No results
with deduplicated as (
    select 
        *, 
        row_number() over (
            partition by cst_id 
            order by cst_create_date desc
        ) as flag_row 
    from {{source('crm_sources', 'cust_info')}}
)

select * from deduplicated 
where flag_row != 1