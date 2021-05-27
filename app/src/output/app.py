import json

from lib.usecase import PollDeletedUseCase, OrganisationCreated


class Request:
    _message = None

    def __init__(self, event):
        self._record = event.get('Records')[0]

    @property
    def message(self) -> dict:
        if self._message is None:
            self._message = json.loads(self._record.get('body'))

        return self._message

    @property
    def event_name(self):
        return self.message.get('event_name')


class Response:
    _results = None

    def set_results(self, results):
        self._results = results

    def flush(self):
        print(self._results)


class App:
    _map = {}
    
    def __init__(self, request: Request, response: Response):
        self._request = request
        self._response = response

    def __call__(self, *args, **kwargs):
        if self._request.event_name in self._map:
            self._response.set_results(
                results=self._map.get(self._request.event_name)(self._request)
            )

            return self._response.flush()

        raise Exception(f"Event type [{self._request.event_name}] not Found")

    def route(self, event_name: str):
        def f(func_name):
            self._map[event_name] = func_name

        return f


def handler(event, context):
    app = App(
        request=Request(event),
        response=Response()
    )

    @app.route('organisation_created')
    def organisation_created(request, **kwargs):
        return OrganisationCreated(
            message=request.message
        ).execute()

    @app.route('poll_deleted')
    def poll_deleted(request, **kwargs):
        return PollDeletedUseCase(
            message=request.message
        ).execute()

    app()


if __name__ == '__main__':
    e = {
        'Records': [{
            'body': json.dumps({
                "event_name": "poll_deleted",
                "attributes": {
                    "organisation_id": 1,
                    "organisation_name": None,
                    "organisation_subscription_tier": None,
                    "event_id": None,
                    "event_name": None,
                    "event_duration": None,
                    "event_published": None,
                    "days_to_event_start": None,
                    "poll_id": 3,
                    "question": None,
                    "options": None
                }
            })
        }]
    }
    handler(e, None)