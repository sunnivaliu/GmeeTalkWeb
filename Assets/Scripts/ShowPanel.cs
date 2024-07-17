using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;

public class ShowPanel : MonoBehaviour
{
    [SerializeField] private Button ShowHideButton;
    [SerializeField] private GameObject dropdown;
    [SerializeField] private GameObject messageArea;

    //[SerializeField] private GameObject message;
    //[SerializeField] private GameObject scrollview;
    //[SerializeField] private GameObject scroll;
    //[SerializeField] private GameObject bar;

    private bool show = true;
    private float originalPositionY;

    void Start()
    {
        originalPositionY = messageArea.GetComponent<RectTransform>().anchoredPosition.y;
        ShowHideButton.onClick.AddListener(ShowHide);

    }

    void ShowHide()
    {
        if (show == true)
        {
            show = false;
            dropdown.SetActive(false);
            RectTransform rectTransform = messageArea.GetComponent<RectTransform>();
            rectTransform.anchoredPosition = new Vector2(rectTransform.anchoredPosition.x, -1000f);
            return;
        }
        else
        {
            show = true;
            dropdown.SetActive(true);
            RectTransform rectTransform = messageArea.GetComponent<RectTransform>();
            rectTransform.anchoredPosition = new Vector2(rectTransform.anchoredPosition.x, originalPositionY);
            return;
        }

    }
}
