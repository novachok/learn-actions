from abc import abstractmethod


class AbstractUseCase:
    def __init__(self, message: dict):
        self._message = message

    @abstractmethod
    def execute(self):
        pass


class PollDeletedUseCase(AbstractUseCase):
    def execute(self):
        self._message.update({
            "organisation_name": "Hopin"
        })

        return self._message


class OrganisationCreated(AbstractUseCase):
    def execute(self):
        self._message.update({
            "organisation_name": "Hopin",
            "organisation_email": "oleksandr.novachok@hopin.to"
        })

        return self._message
