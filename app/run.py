import analytics
from datetime import datetime
from uuid import uuid4


def on_error(error, items):
    print("------")
    print("Error:", error)
    print("Items:", items)
    print("------")

# arn:aws:lambda:eu-west-1:464201367303:function:novachok-segment-poc
# arn:aws:iam::464201367303:policy/novachok-segment-poc

def main():
    analytics.write_key = '3rHQjtpsChoscuZfYiAqy9YCNh3i0hoC'
    analytics.debug = True
    analytics.on_error = on_error

    uid = uuid4().hex

    analytics.identify(uid, {
        'name': 'Michael Bolton',
        'email': 'mbolton@example.com',
        'created_at': datetime.utcnow()
    })

    analytics.track(uid, 'Signed Up', {
        'plan': 'Enterprise',
        'test': 'Value'
    })

    analytics.page(uid, 'Docs', 'Python', {
        'url': 'http://google.com'
    })

    analytics.screen(uid, 'Settings', 'Brightness', {
        'from': 'Home Screen'
    })


if __name__ == '__main__':
    main()
