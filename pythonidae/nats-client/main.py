import asyncio
import nats
from nats.errors import ConnectionClosedError, TimeoutError, NoServersError
import ssl

nats_address = "domain/IPaddress:4111"
nats_hostheader = ""

async def main():

    ssl_ctx = ssl.create_default_context(purpose=ssl.Purpose.SERVER_AUTH)
    ssl_ctx.minimum_version = ssl.PROTOCOL_TLSv1_2
    ssl_ctx.load_verify_locations(cafile='ca_server_bundle.pem')
    ssl_ctx.load_cert_chain(certfile='certificate.pem',
                        keyfile='private.key')
    #ssl_ctx.set_ciphers("ECDHE-RSA-AES256-GCM-SHA384")

    print(ssl_ctx.get_ciphers())

    nc = await nats.connect(servers=["tls://nats_address"], tls=ssl_ctx, tls_hostname=nats_hostheader)

    async def message_handler(msg):
        subject = msg.subject
        reply = msg.reply
        data = msg.data.decode()
        print("Received a message on '{subject} {reply}': {data}".format(
            subject=subject, reply=reply, data=data))

    sub = await nc.subscribe(">", cb=message_handler)
    
    await sub.unsubscribe(limit=20)

if __name__ == '__main__':
    asyncio.run(main())
