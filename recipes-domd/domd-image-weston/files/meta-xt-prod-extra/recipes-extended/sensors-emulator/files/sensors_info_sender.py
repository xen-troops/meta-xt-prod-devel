import json
import re
import signal
import sys
import time
from http.server import BaseHTTPRequestHandler, HTTPServer
from threading import Thread

from emulator import VertexPool, Emulator
from sensors_config import EMULATOR_UPDATE_TIME, SERVER_LISTEN_HOST, SERVER_LISTEN_PORT

current_state = None


def signal_handler(signum, frame):
    if signum == 15:
        server.shutdown()
        print('got SIGTERM')
        sys.exit(0)


class HttpResponseException(Exception):
    def __init__(self, code, message=None):
        self.code = code
        self.message = message


class BadRequestException(HttpResponseException):
    def __init__(self, message=None):
        super().__init__(400, message)


class NotFoundException(HttpResponseException):
    def __init__(self, message=None):
        super().__init__(404, message)


class EmulatorCommandsRequestHandler(BaseHTTPRequestHandler):
    def setup(self):
        super().setup()
        self._urls = [
            (r'^/state/?$', self._state),
            (r'^/start/?$', self._start),
            (r'^/stop/?$', self._stop),
            (r'^/madness/(?P<value>\d+(\.\d+)?)/?$', self._madness),
        ]

    def do_GET(self):
        request_path = self.path
        try:
            self._handle(request_path)
        except HttpResponseException as ex:
            if ex.message is not None:
                self.response(ex.code, ex.message.encode('utf8'))
            else:
                self.response(ex.code)
        except Exception as ex:
            import traceback
            print("Unexpected exception: {}".format(ex))
            print(''.join(traceback.format_exception(None, ex, ex.__traceback__)), file=sys.stderr, flush=True)
            self.response(500)

    def response(self, status, body=None):
        self.send_response(status)
        self.end_headers()
        if body is not None:
            self.wfile.write(body)

    def _handle(self, request_path):
        for url_pattern, handle_function in self._urls:
            m = re.match(url_pattern, request_path)
            if m:
                handle_function(m)
                return
        raise NotFoundException()

    def _state(self, match):
        body = json.dumps(current_state).encode('utf8')
        self.response(200, body)

    def _start(self, match):
        print("start")
        emulator.command_to_stop = False
        self.response(200)

    def _stop(self, match):
        print("stop")
        emulator.command_to_stop = True
        self.response(200)

    def _madness(self, match):
        value = match.group('value')
        print("madness set to {}".format(value))
        madness = float(value)
        if madness == 0:
            emulator.change_madness_periodically = True
        elif 0 < madness <= 1:
            emulator.change_madness_periodically = False
            emulator.madness = madness
        else:
            raise BadRequestException(message='Madness must be between 0 and 1')
        self.response(200)


def state_update_loop(emulator):
    global current_state
    while True:
        emulator.update(EMULATOR_UPDATE_TIME)
        data = emulator.get_data()
        data['timestamp'] = time.time()
        current_state = data
        # Uncomment for DEBUG printouts
        #print(data)
        time.sleep(EMULATOR_UPDATE_TIME)


if __name__ == '__main__':
    vp = VertexPool('map.json')
    emulator = Emulator(vp)
    signal.signal(signal.SIGTERM, signal_handler)
    server = HTTPServer((SERVER_LISTEN_HOST, SERVER_LISTEN_PORT), EmulatorCommandsRequestHandler)
    server_thread = Thread(target=server.serve_forever, daemon=False)
    server_thread.start()
    try:
        state_update_loop(emulator)
    except KeyboardInterrupt:
        server.shutdown()
        print("received keyboard interrupt. shutting down")
