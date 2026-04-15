with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="date('2016-01-01')",
        end_date="date('2018-12-31')"
    ) }}

)

select
    cast(date_day as date) as date,

    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,

    format_date('%Y-%m', date_day) as year_month,
    extract(week from date_day) as week,

    extract(dayofweek from date_day) as day_of_week,
    format_date('%A', date_day) as day_name,

    case
        when extract(dayofweek from date_day) in (1,7) then 1
        else 0
    end as is_weekend

from date_spine

