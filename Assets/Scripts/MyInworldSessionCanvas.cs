
/*************************************************************************************************
* Copyright 2022-2024 Theai, Inc. dba Inworld AI
*
* Use of this source code is governed by the Inworld.ai Software Development Kit License Agreement
* that can be found in the LICENSE.md file or at https://www.inworld.ai/sdk-license
*************************************************************************************************/
using Inworld.Interactions;
using Inworld.Runtime.RPM;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using UnityEngine;
using UnityEngine.UI;

namespace Inworld.Sample.RPM
{
    public class MyInworldSessionCanvas : DemoCanvas
    {
        [SerializeField] InworldCharacter m_Character;
        [SerializeField] float m_PingDuration = 1f;

        string ipv4;

        /// <summary>
        /// Clear the saved data
        /// </summary>
        public void NewSpeakGame(bool loadHistory)
        {
            if (!loadHistory)
                InworldController.Client.SessionHistory = "";
            InworldController.CharacterHandler.Register(m_Character);
        }

        protected override void OnCharacterJoined(InworldCharacter character)
        {
            base.OnCharacterJoined(character);
            m_Title.text = $"{character.Name} joined";
            Debug.Log(character.Name + " joined");
        }

        protected override void OnCharacterLeft(InworldCharacter character)
        {
            base.OnCharacterLeft(character);
            m_Title.text = $"{character.Name} left";
            Debug.Log(character.Name + " left");
        }

        /// <summary>
        /// Save game
        /// </summary>
        public void SaveGame() => InworldController.Client.GetHistoryAsync(InworldController.Instance.CurrentScene);
        protected void Awake()
        {
            if (string.IsNullOrEmpty(ipv4))
                ipv4 = Dns.GetHostAddresses(InworldController.Client.Server.web)[0].ToString();
            NewSpeakGame(false);
        }


        protected override void Start()
        {
            base.Start();
        }

        protected IEnumerator _RestartAsync()
        {
            if (InworldController.Status == InworldConnectionStatus.Connected)
            {
                InworldController.Instance.Disconnect();
            }
            while (InworldController.Status != InworldConnectionStatus.Idle)
            {
                yield return new WaitForFixedUpdate();
            }
            InworldController.Instance.Init();
        }

    }
}
