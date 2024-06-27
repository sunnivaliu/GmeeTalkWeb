using OpenAI;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Microphone = Estrada.Microphone;

namespace Samples.Whisper
{
    public class MyWhisper : MonoBehaviour
    {
        [SerializeField] private Button recordButton;
        [SerializeField] private Image progressBar;
        [SerializeField] private Text message;
        [SerializeField] private Dropdown dropdown;
        [SerializeField] private MyTextGenerator MyTextGeneratorInstance;

        private readonly string fileName = "output.wav";
        private readonly int duration = 20;

        private AudioClip clip;
        private bool isRecording;
        private float time;
        private OpenAIApi openai = new OpenAIApi("sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D");

        //Output to text model
        public static string TranscribedText;

        private IEnumerator Start()
        {
//#if UNITY_WEBGL && !UNITY_EDITOR
//            dropdown.options.Add(new Dropdown.OptionData("Microphone not supported on WebGL"));
//#else

            if (Microphone.RequiresPermission())
            {
                yield return Microphone.RequestPermission();
            }
            if (!Microphone.HasPermission())
            {
                Debug.LogError("Mic Permission Not Granted");
                yield break;
            }

            foreach (var device in Microphone.devices)
            {
                dropdown.options.Add(new Dropdown.OptionData(device));
            }
            recordButton.onClick.AddListener(StartRecording);
            dropdown.onValueChanged.AddListener(ChangeMicrophone);

            var index = PlayerPrefs.GetInt("user-mic-device-index");
            dropdown.SetValueWithoutNotify(index);
//#endif
        }

        private void ChangeMicrophone(int index)
        {
            PlayerPrefs.SetInt("user-mic-device-index", index);
        }

        private void StartRecording()
        {
            isRecording = true;
            recordButton.enabled = false;

            var index = PlayerPrefs.GetInt("user-mic-device-index") - 1; //Manually added - 1 to match the drop down

            ////Uncomment this when building in WebGL
//#if !UNITY_WEBGL
//            clip = Microphone.Start(dropdown.options[index].text, false, duration, 44100);
//#endif

            clip = Microphone.Start(dropdown.options[index].text, false, duration, 44100);

        }

        private async void EndRecording()
        {
            message.text = "Transcripting...";

//#if !UNITY_WEBGL
//            Microphone.End(null);
//#endif

            byte[] data = MySaveAudio.Save(fileName, clip);

            var req = new CreateAudioTranscriptionsRequest
            {
                FileData = new FileData() { Data = data, Name = "audio.wav" },
                // File = Application.persistentDataPath + "/" + fileName,
                Model = "whisper-1",
                Language = "en"
            };
            var res = await openai.CreateAudioTranscription(req);

            progressBar.fillAmount = 0;
            message.text = res.Text;
            TranscribedText = res.Text;
            recordButton.enabled = true;

            MyTextGeneratorInstance.SendReply(); // Send to TextGenerator
        }

        private void Update()
        {
            if (isRecording)
            {
                time += Time.deltaTime;
                progressBar.fillAmount = time / duration;

                if (time >= duration)
                {
                    time = 0;
                    isRecording = false;
                    EndRecording();
                }
            }
        }
    }
}
