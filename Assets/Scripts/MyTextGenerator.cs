using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

namespace OpenAI
{
    public class MyTextGenerator : MonoBehaviour
    {
        [SerializeField] private InputField inputField;
        [SerializeField] public Button button;
        [SerializeField] private ScrollRect scroll;

        [SerializeField] private RectTransform sent;
        [SerializeField] private RectTransform received;


        private float height;
        public GameObject PlayAudioObject;
        private PlayAudio PlayAudioInstance;

        //API KEY
        private OpenAIApi openai = new OpenAIApi("sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D");

        private List<ChatMessage> messages = new List<ChatMessage>();
        private string prompt = "Act as a HR sitting in front of an Interviewee candidate in a chat room and reply to the questions. Don't break character. Don't ever mention that you are an AI model.";

        private void Start()
        {
            button.onClick.AddListener(SendReply); //API is called once 'Send' is pressed

            var initMessage = new ChatMessage()
            {
                Content = "GPT Answers Here",
            };
            AppendMessage(initMessage);
        }

        public async void SendReply()
        {
            ////Default
            //var newMessage = new ChatMessage()
            //{
            //    Role = "user",
            //    Content = inputField.text
            //};

            var newMessage = new ChatMessage()
            {
                Role = "user",
                Content = Samples.Whisper.MyWhisper.TranscribedText
            };
            if (newMessage.Content == null)
            {
                newMessage.Content = inputField.text;
            }
            Debug.Log("Audio Transcribed: " + Samples.Whisper.MyWhisper.TranscribedText);
            AppendMessage(newMessage);

            if (messages.Count == 0) newMessage.Content = prompt + "\n" + newMessage.Content;
            messages.Add(newMessage);

            button.enabled = false;
            inputField.text = "";
            inputField.enabled = false;

            var completionResponse = await openai.CreateChatCompletion(new CreateChatCompletionRequest()
            {
                Model = "gpt-4o",
                Messages = messages
            });

            if (completionResponse.Choices != null && completionResponse.Choices.Count > 0)
            {
                var message = completionResponse.Choices[0].Message;
                message.Content = message.Content.Trim();
                messages.Add(message);
                AppendMessage(message); //Push to canvas


                PlayAudioInstance = PlayAudioObject.GetComponent<PlayAudio>();
                PlayAudioInstance.TurnReplyToAudio(message.Content);
            }
            else
            {
                Debug.LogWarning("No text was generated from this prompt.");
            }

            button.enabled = true;
            inputField.enabled = true;
            
        }

        private void AppendMessage(ChatMessage message)
        {
            scroll.content.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0);
            var item = Instantiate(message.Role == "user" ? sent : received, scroll.content);
            item.GetChild(0).GetChild(0).GetComponent<Text>().text = message.Content;
            item.anchoredPosition = new Vector2(0, -height);
            LayoutRebuilder.ForceRebuildLayoutImmediate(item);
            height += item.sizeDelta.y;
            scroll.content.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, height);
            scroll.verticalNormalizedPosition = 0;
        }

    }
}

