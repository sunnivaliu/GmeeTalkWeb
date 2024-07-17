using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;

namespace OpenAI
{
    public class MyTextGenerator : MonoBehaviour
    {
        [SerializeField] private InputField inputField;
        [SerializeField] public Button button;
        [SerializeField] private Button startButton;
        [SerializeField] private ScrollRect scroll;

        [SerializeField] private RectTransform sent;
        [SerializeField] private RectTransform received;

        private float height;
        public GameObject PlayAudioObject;
        private PlayAudio PlayAudioInstance;

        //API KEY
        private OpenAIApi openai = new OpenAIApi("sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D");
        private List<ChatMessage> messages = new List<ChatMessage>();
        //private string prompt = "Act as a HR sitting in front of an Interviewee candidate in a chat room and reply to the questions. Don't break character. Don't ever mention that you are an AI model.";

        private bool started = false;

        private void Start()
        {
            button.onClick.AddListener(SendReply); //API is called once 'Send' is pressed
            startButton.onClick.AddListener(RestartChat);
        }

        void Update() //DEBUG
        {
            //if (Input.GetKey(KeyCode.Space))
            //{
            //    Debug.Log("Restart Chat");
            //    RestartChat();
            //}
        }

        private void RestartChat()
        {
            messages = new List<ChatMessage>();
            var systemMessage = new ChatMessage()
            {
                Role = "system",
                Content = CreatePromptings.SystemPrompt,
            };
            messages.Add(systemMessage);
            started = false;
            SendReply();
            started = true;

            EndingCreation.HideFeedback();
        }

        public async void SendReply()
        {
            ////Default
            //var newMessage = new ChatMessage()
            //{
            //    Role = "user",
            //    Content = inputField.text
            //};
            Debug.Log("Audio Transcribed: " + Samples.Whisper.MyWhisper.TranscribedText);

            //audio input
            var newMessage = new ChatMessage()
            {
                Role = "user",
                Content = Samples.Whisper.MyWhisper.TranscribedText
            };
            //reset audio input
            Samples.Whisper.MyWhisper.TranscribedText = "";

            //If no input
            if (started == true && (newMessage.Content == null || newMessage.Content.Length < 5))
            {
                newMessage.Content = inputField.text;
                if (inputField.text == null || inputField.text.Length < 5)
                {
                    newMessage.Content = CreatePromptings.PlaceholderResponse;
                }
            }
            //starter input
            if (started == false)
            {
                newMessage.Content = CreatePromptings.InitScript;
            }

            AppendMessage(newMessage);
            messages.Add(newMessage);
            
            foreach (var item in messages)
            {
                Debug.Log(messages.Count + " " + item.Role + " "+ item.Content + " ");
            }

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

                //Check if this is the ending
                EndingCreation.checkEnding(message.Content);

                PlayAudioInstance = PlayAudioObject.GetComponent<PlayAudio>();
                PlayAudioInstance.TurnReplyToAudio(message.Content);

                //Push to canvas
                StartCoroutine(AddAndAppendMessageWithDelay(message, 2f));
                //AppendMessage(message);
            }
            else
            {
                Debug.LogWarning("No text was generated from this prompt.");
            }

            button.enabled = true;
            inputField.enabled = true; 
           
        }

        IEnumerator AddAndAppendMessageWithDelay(ChatMessage message, float delay)
        {
            yield return new WaitForSeconds(delay);
            AppendMessage(message);
        }

        public void ErrorMessage()
        {
            var errorMessage = new ChatMessage()
            {
                Content = CreatePromptings.ErrorScript,
            };
            AppendMessage(errorMessage);
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

        private void OnDestroy()
        {
            height = 0;
            foreach (Transform child in scroll.content)
            {
                Destroy(child.gameObject);
            }
            scroll.content.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0);
            scroll.verticalNormalizedPosition = 1;
        }

    }
}

