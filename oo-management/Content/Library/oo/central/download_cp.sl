namespace: oo.central
flow:
  name: download_cp
  inputs:
    - cp_id: 7821bf90-bfd5-4216-94a1-a528c6735f7f
    - file_path: "c:\\\\temp\\\\second.jar"
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${get_sp('oo.central_url') + '/rest/latest/content-file/' + cp_id}"
            - username: "${get_sp('oo.username')}"
            - password:
                value: "${get_sp('oo.password')}"
                sensitive: true
            - destination_file: '${file_path}'
            - method: GET
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 94
        'y': 121
        navigate:
          a3b7a800-f0f1-5e56-c88f-6ca2227313e2:
            targetId: 87c7a62d-9699-c729-87c5-a901061e518a
            port: SUCCESS
    results:
      SUCCESS:
        87c7a62d-9699-c729-87c5-a901061e518a:
          x: 262
          'y': 125
