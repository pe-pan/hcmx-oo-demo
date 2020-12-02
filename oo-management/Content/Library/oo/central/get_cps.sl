namespace: oo.central
flow:
  name: get_cps
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('oo.central_url')+'/rest/latest/content-packs'}"
            - auth_type: basic
            - username: "${get_sp('oo.username')}"
            - password:
                value: "${get_sp('oo.password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - cps_json: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: '$.*.id'
        publish:
          - cp_ids: "${','.join(eval(return_result))}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cps_json: '${cps_json}'
    - cp_ids: '${cp_ids}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 51
        'y': 128
      json_path_query:
        x: 257
        'y': 128
        navigate:
          75293953-8960-d096-11e0-8747d7b3aad3:
            targetId: 3393f849-783c-99a0-6737-d668cf5ba0c0
            port: SUCCESS
    results:
      SUCCESS:
        3393f849-783c-99a0-6737-d668cf5ba0c0:
          x: 447
          'y': 129
