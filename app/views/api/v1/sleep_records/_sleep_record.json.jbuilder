if sleep_record
    json.extract! sleep_record, :id, :start_time, :end_time
end
