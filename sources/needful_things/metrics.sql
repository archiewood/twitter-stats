with level_one as (
    select
        unnest(data.result.result.organic_metrics_time_series).timestamp.iso8601_time as timestamp,
        unnest(data.result.result.organic_metrics_time_series).metric_values as metric_array
    from 'sources/needful_things/response.json'
)
select
    timestamp, 
    unnest(metric_array).metric_type as metric,  
    unnest(metric_array).metric_value as value
from level_one 
order by 2,1