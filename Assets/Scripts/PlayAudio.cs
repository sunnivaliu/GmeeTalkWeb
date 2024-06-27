using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using UnityEngine.Networking;
using Inworld.Sample.RPM;

namespace OpenAI
{
    public class PlayAudio : MonoBehaviour
    {
        public GameObject audioObject;
        private AudioSource audioSource;

        public GameObject TextGenerator;
        private MyTextGenerator MyTextGeneratorInstance;
        
        private bool updatingLipSync = false;

        void Start()
        {
            audioSource = audioObject.GetComponent<AudioSource>();
            MyTextGeneratorInstance = TextGenerator.GetComponent<MyTextGenerator>();
            if (audioSource.clip == null) { Debug.Log("Audio source is null"); }
            Debug.Log("path: " + Directory.GetParent(Application.dataPath).FullName);
        }

        private class TTSPayload
        {
            public string model;
            public string input;
            public string voice;
            public string response_format;
            public float speed;
        }

        public void TurnReplyToAudio(string ResponseText)
        {
            TextToAudio(ResponseText);
        }

        private async void TextToAudio(string ResponseText)
        {
            await SendRequest(ResponseText);

            ////Original Reloading Method
            //byte[] audioData = await SendRequest(ResponseText);
            //if (audioData != null)
            //{
            //Debug.Log("Audio data received. " + audioData[0] + audioData[10]);
            //PlayResponse(audioData); 

            ////Use Inworld to turn to audio clip
            //AudioClip audioClip = Inworld.WavUtilityFromInworld.ToAudioClip(audioData);
            //if (audioClip != null)
            //{
            //    audioSource.clip = audioClip;
            //    audioSource.Play();
            //    Debug.Log("Playing audio.");
            //}
            //}
            //else
            //{
            //    Debug.LogError("Failed to receive audio data.");
            //}
        }

        private async Task<byte[]> SendRequest(string ResponseText)
        {
            Debug.Log("Sending new request to OpenAI TTS. " + ResponseText);
            TTSPayload payload = new TTSPayload
            {
                model = "tts-1",
                input = ResponseText,
                voice = "alloy",
                response_format = "mp3",
                speed = 1f
            };
            string jsonPayload = JsonUtility.ToJson(payload);

            //TEST
            using (UnityWebRequest www = new UnityWebRequest("https://api.openai.com/v1/audio/speech", "POST"))
            {
                byte[] bodyRaw = Encoding.UTF8.GetBytes(jsonPayload);
                www.uploadHandler = new UploadHandlerRaw(bodyRaw);
                www.downloadHandler = new DownloadHandlerAudioClip("https://api.openai.com/v1/audio/speech", AudioType.MPEG);
                www.SetRequestHeader("Content-Type", "application/json");
                www.SetRequestHeader("Authorization", "Bearer " + "sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D");

                await www.SendWebRequest();

                if (www.result == UnityWebRequest.Result.ConnectionError || www.result == UnityWebRequest.Result.ProtocolError)
                {
                    Debug.LogError("Error: " + www.error);
                    //Report Error to the chatbox
                    SendErrorMessage();

                }
                else if (www.result == UnityWebRequest.Result.Success)
                {
                    AudioClip audioClip = DownloadHandlerAudioClip.GetContent(www);
                    audioSource = audioObject.GetComponent<AudioSource>();
                    audioSource.clip = audioClip;
                    audioSource.Play();
                    updatingLipSync = true;
                }
            }

            //UnityWebRequest request = new UnityWebRequest("https://api.openai.com/v1/audio/speech", "POST");

            //byte[] bodyRaw = Encoding.UTF8.GetBytes(jsonPayload);
            //request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            //request.downloadHandler = new DownloadHandlerBuffer();
            //request.SetRequestHeader("Content-Type", "application/json");
            //request.SetRequestHeader("Authorization", "Bearer " + "sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D"); //API KEY

            //await request.SendWebRequest();

            //if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            //{
            //    Debug.LogError("Error: " + request.error);
            //    return null;
            //}
            //else
            //{
            //    return request.downloadHandler.data;
            //}
            return null;
        }

        private void SendErrorMessage()
        {
            MyTextGeneratorInstance.ErrorMessage();
        }

        private void FixedUpdate()
        {
            if ((audioSource != null) && updatingLipSync == true)
            {
                if (audioSource.isPlaying)
                {
                    InworldFacialAnimationRPM.CallProcessLipSync();

                }
                else
                {
                    InworldFacialAnimationRPM.CallStopLipSync();
                    updatingLipSync = false;
                }
            }

        }


        //UNUSED///////////////////////////////////////////////////////
        private void PlayResponse(byte[] audioData)
        {
            if (audioData != null)
            {
                string filePath = Path.Combine(Path.Combine(Application.persistentDataPath + "/audio.mp3")); //Application.persistentDataPath Directory.GetParent(Application.dataPath).FullName
                Debug.Log("Audio filePath: " + filePath);
                File.WriteAllBytes(filePath, audioData);
                LoadAndPlayAudio(audioData, filePath);
            }
            else Debug.LogError("audioData is NULL");
        }

        private async void LoadAndPlayAudio(byte[] audioData, string filePath) 
        {
            using UnityWebRequest www = UnityWebRequestMultimedia.GetAudioClip("file://" + filePath, AudioType.MPEG);
            await www.SendWebRequest();

            if (www.result == UnityWebRequest.Result.ConnectionError || www.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError("Error: " + www.error);
            }

            if (www.result == UnityWebRequest.Result.Success)
            {
                AudioClip audioClip = DownloadHandlerAudioClip.GetContent(www);
                audioSource = audioObject.GetComponent<AudioSource>();
                audioSource.clip = audioClip;
                audioSource.Play();
            }
            else Debug.LogError("Audio file loading error: " + www.error);
        }

    }
}






////Net does not work in WebGL
///using System.Net.Http.Headers;
//private async Task<byte[]> RequestTextToSpeech(string ResponseText, float speed = 1f)
//{
//    Debug.Log("Sending new request to OpenAI TTS. " + ResponseText);
//    using var httpClient = new HttpClient();
//    httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D");

//    TTSPayload payload = new TTSPayload
//    {
//        model = "tts-1",
//        input = ResponseText,
//        voice = "alloy",
//        response_format = "mp3",
//        speed = speed
//    };

//    string jsonPayload = JsonUtility.ToJson(payload);

//    var httpResponse = await httpClient.PostAsync(
//        "https://api.openai.com/v1/audio/speech",
//        new StringContent(jsonPayload, Encoding.UTF8, "application/json")
//    );

//    byte[] audioD = await httpResponse.Content.ReadAsByteArrayAsync();
//    if (httpResponse.IsSuccessStatusCode) return audioD;

//    Debug.Log("Error: " + httpResponse.StatusCode);
//    return null;
//}

