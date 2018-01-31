using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using Twilio;
using Twilio.Types;
using Twilio.Rest.Api.V2010.Account;

namespace AzureStackUpdateNotification
{
    public static class SendMessage
    {
        [FunctionName("SendMessage")]
        public static HttpResponseMessage Run([HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = "SendMessage/{parameters}")]HttpRequestMessage req, string parameters, TraceWriter log)
        {
            log.Info("C# HTTP trigger function processed a request.");
            PhoneNumber to = new PhoneNumber(parameters.Split(':')[0]);
            string state = parameters.Split(':')[1];

            const string accountSid = "<AccountSID-From-Twilio-Dashboard>";
            const string authToken = "<AuthToken-From-Twilio-Dashboard>";
            TwilioClient.Init(accountSid, authToken);
            //
            MessageResource message = MessageResource.Create(to,
                                                 from: new PhoneNumber("<Active-Number-From-Twilio-PhoneNumber-Menu>"),
                                                 body: "Azure Stack update is " + state);

            return req.CreateResponse(HttpStatusCode.OK, "Azure Stack update is " + state + ". Message sent to " + to.ToString());
        }
    }
}
